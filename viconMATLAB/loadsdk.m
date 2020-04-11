% Program options
TransmitMulticast = false;
EnableHapticFeedbackTest = false;
HapticOnList = {'ViconAP_001';'ViconAP_002'};
SubjectFilterApplied = false;

% Check whether these variables exist, as they can be set by the command line on launch
% If you run the script with Command Window in Matlab, these workspace vars could persist the value from previous runs even not set in the Command Window
% You could clear the value with "clearvars"
if ~exist( 'bReadCentroids' )
  bReadCentroids = false;
end

if ~exist( 'bReadRays' )
  bReadRays = false;
end

if ~exist( 'bTrajectoryIDs' )
  bTrajectoryIDs = false;
end

if ~exist( 'axisMapping' )
  axisMapping = 'ZUp';
end

% example for running from commandline in the ComandWindow in Matlab
% e.g. bLightweightSegment = true;HostName = 'localhost:801';ViconDataStreamSDK_MATLABTest
if ~exist('bLightweightSegment')
  bLightweightSegment = false;
end

% Pass the subjects to be filtered in
% e.g. Subject = {'Subject1'};HostName = 'localhost:801';ViconDataStreamSDK_MATLABTest
EnableSubjectFilter  = exist('subjects');

% A dialog to stop the loop
%MessageBox = msgbox( 'Stop DataStream Client', 'Vicon DataStream SDK' );

% Load the SDK
%fprintf( 'Loading SDK...' );
Client.LoadViconDataStreamSDK();
%fprintf( 'done\n' );

% Program options
if ~exist( 'HostName' )
  HostName = 'localhost:801';
end

% fprintf( 'Centroids Enabled: %s\n', mat2str( bReadCentroids ) );
% fprintf( 'Rays Enabled: %s\n', mat2str( bReadRays ) );
% fprintf( 'Trajectory IDs Enabled: %s\n', mat2str( bTrajectoryIDs ) );
% fprintf( 'Lightweight Segment Data Enabled: %s\n', mat2str( bLightweightSegment ) );
% fprintf('Axis Mapping: %s\n', axisMapping );

if exist('undefVar')
  fprintf('Undefined Variable: %s\n', mat2str( undefVar ) );
end

% Make a new client
MyClient = Client();

% Connect to a server
%fprintf( 'Connecting to %s ...', HostName );
while ~MyClient.IsConnected().Connected
  % Direct connection
  MyClient.Connect( HostName );
  
  % Multicast connection
  % MyClient.ConnectToMulticast( HostName, '224.0.0.0' );
  
 % fprintf( '.' );
end
%fprintf( '\n' );

% Enable some different data types
MyClient.EnableSegmentData();
MyClient.EnableMarkerData();
MyClient.EnableUnlabeledMarkerData();
MyClient.EnableDeviceData();
if bReadCentroids
  MyClient.EnableCentroidData();
end
if bReadRays
  MyClient.EnableMarkerRayData();
end
if bLightweightSegment
  MyClient.DisableLightweightSegmentData();
  Output_EnableLightweightSegment = MyClient.EnableLightweightSegmentData();
  if Output_EnableLightweightSegment.Result.Value ~= Result.Success
    fprintf( 'Server does not support lightweight segment data.\n' );
  end
end

% fprintf( 'Segment Data Enabled: %s\n',             AdaptBool( MyClient.IsSegmentDataEnabled().Enabled ) );
% fprintf( 'Lightweight Segment Data Enabled: %s\n', AdaptBool( MyClient.IsLightweightSegmentDataEnabled().Enabled ) );
% fprintf( 'Marker Data Enabled: %s\n',              AdaptBool( MyClient.IsMarkerDataEnabled().Enabled ) );
% fprintf( 'Unlabeled Marker Data Enabled: %s\n',    AdaptBool( MyClient.IsUnlabeledMarkerDataEnabled().Enabled ) );
% fprintf( 'Device Data Enabled: %s\n',              AdaptBool( MyClient.IsDeviceDataEnabled().Enabled ) );
% fprintf( 'Centroid Data Enabled: %s\n',            AdaptBool( MyClient.IsCentroidDataEnabled().Enabled ) );
% fprintf( 'Marker Ray Data Enabled: %s\n',          AdaptBool( MyClient.IsMarkerRayDataEnabled().Enabled ) );

MyClient.SetBufferSize(1);
% Set the streaming mode
MyClient.SetStreamMode( StreamMode.ClientPull );
% MyClient.SetStreamMode( StreamMode.ClientPullPreFetch );
% MyClient.SetStreamMode( StreamMode.ServerPush );

% Set the global up axis
if axisMapping == 'XUp'
  MyClient.SetAxisMapping( Direction.Up, ...
                          Direction.Forward,      ...
                          Direction.Left ); % X-up
elseif axisMapping == 'YUp'
  MyClient.SetAxisMapping( Direction.Forward, ...
                         Direction.Up,    ...
                         Direction.Right );    % Y-up
else
  MyClient.SetAxisMapping( Direction.Forward, ...
                         Direction.Left,    ...
                         Direction.Up );    % Z-up
end

Output_GetAxisMapping = MyClient.GetAxisMapping();
%fprintf( 'Axis Mapping: X-%s Y-%s Z-%s\n', Output_GetAxisMapping.XAxis.ToString(), ...
%                                           Output_GetAxisMapping.YAxis.ToString(), ...
%                                           Output_GetAxisMapping.ZAxis.ToString() );


% Discover the version number
Output_GetVersion = MyClient.GetVersion();
%fprintf( 'Version: %d.%d.%d.%d\n', Output_GetVersion.Major, ...
%                                Output_GetVersion.Minor, ...
%                                Output_GetVersion.Point, ...
%                                Output_GetVersion.Revision );
  
if TransmitMulticast
  MyClient.StartTransmittingMulticast( 'localhost', '224.0.0.0' );
end  

% if TransmitMulticast
%   MyClient.StopTransmittingMulticast();
% end  
% 
% % Disconnect and dispose
% MyClient.Disconnect();
% 
% % Unload the SDK
% %fprintf( 'Unloading SDK...' );
% Client.UnloadViconDataStreamSDK();
% %fprintf( 'done\n' );
