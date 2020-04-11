Counter = 1;
% Loop until the message box is dismissed
%while ishandle( MessageBox )
 % drawnow;
 % Counter = Counter + 1;
  
  % Get a frame
 % fprintf( 'Waiting for new frame...' );
  while MyClient.GetFrame().Result.Value ~= Result.Success
    fprintf( '.' );
  end% while
  %fprintf( '\n' );  
  
  if EnableHapticFeedbackTest
    if mod( Counter,2 ) == 0
      for i = 1:length( HapticOnList )
          DeviceName = HapticOnList{i};
          Output_GetApexFeedback = MyClient.SetApexDeviceFeedback( DeviceName, true );
          if Output_GetApexFeedback.Result.Value == Result.Success
              fprintf( 'Turn haptic feedback on for device: %s\n', DeviceName );
          elseif Output_GetApexFeedback.Result.Value == Result.InvalidDeviceName
              fprintf( 'Device doesn''t exist: %s\n', DeviceName );
          end
      end
    end
    if mod( Counter, 20 ) == 0
      for i = 1:length( HapticOnList )
          DeviceName = HapticOnList{i};
          Output_GetApexFeedback = MyClient.SetApexDeviceFeedback( DeviceName, false );
          if Output_GetApexFeedback.Result.Value == Result.Success
              fprintf( 'Turn haptic feedback on for device: %s\n', DeviceName );
          end
      end
    end
  end
      

  % Get the frame number
  Output_GetFrameNumber = MyClient.GetFrameNumber();
  fprintf( 'Frame Number: %d\n', Output_GetFrameNumber.FrameNumber );

  % Get the frame rate
  Output_GetFrameRate = MyClient.GetFrameRate();
  fprintf( 'Frame rate: %g\n', Output_GetFrameRate.FrameRateHz );

  for FrameRateIndex = 1:MyClient.GetFrameRateCount().Count
    FrameRateName  = MyClient.GetFrameRateName( FrameRateIndex ).Name;
    FrameRateValue = MyClient.GetFrameRateValue( FrameRateName ).Value;

    fprintf( '%s: %gHz\n', FrameRateName, FrameRateValue );
  end% for  

  fprintf( '\n' );
  % Get the timecode
  Output_GetTimecode = MyClient.GetTimecode();
  fprintf( 'Timecode: %dh %dm %ds %df %dsf %s %d %d %d\n\n',    ...
                     Output_GetTimecode.Hours,                  ...
                     Output_GetTimecode.Minutes,                ...
                     Output_GetTimecode.Seconds,                ...
                     Output_GetTimecode.Frames,                 ...
                     Output_GetTimecode.SubFrame,               ...
                     AdaptBool( Output_GetTimecode.FieldFlag ), ...
                     Output_GetTimecode.Standard.Value,         ...
                     Output_GetTimecode.SubFramesPerFrame,      ...
                     Output_GetTimecode.UserBits );

  % Get the latency
  %fprintf( 'Latency: %gs\n', MyClient.GetLatencyTotal().Total );
  
  for LatencySampleIndex = 1:MyClient.GetLatencySampleCount().Count
    SampleName  = MyClient.GetLatencySampleName( LatencySampleIndex ).Name;
    SampleValue = MyClient.GetLatencySampleValue( SampleName ).Value;

    fprintf( '  %s %gs\n', SampleName, SampleValue );
  end% for  
  fprintf( '\n' );
                     
  if EnableSubjectFilter && ~SubjectFilterApplied 
    for SubjectIndex = 1: length( Subject )
      Output_SubjectFilter = MyClient.AddToSubjectFilter(char( Subject(SubjectIndex)));
      SubjectFilterApplied = SubjectFilterApplied || Output_SubjectFilter.Result.Value == Result.Success;
    end
  end
  
  % Count the number of subjects
  SubjectCount = MyClient.GetSubjectCount().SubjectCount
  %fprintf( 'Subjects (%d):\n', SubjectCount );
  for SubjectIndex = 1:SubjectCount
    %fprintf( '  Subject #%d\n', SubjectIndex - 1 );
    
    % Get the subject name
    SubjectName = MyClient.GetSubjectName( SubjectIndex ).SubjectName;
    fprintf( '    Name: %s\n', SubjectName );
    
    % Get the root segment
    RootSegment = MyClient.GetSubjectRootSegmentName( SubjectName ).SegmentName;
    %fprintf( '    Root Segment: %s\n', RootSegment );

    % Count the number of segments
    SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
   % fprintf( '    Segments (%d):\n', SegmentCount );
    for SegmentIndex = 1:SegmentCount
      %fprintf( '      Segment #%d\n', SegmentIndex - 1 );
      
      % Get the segment name
      SegmentName = MyClient.GetSegmentName( SubjectName, SegmentIndex ).SegmentName;
      %fprintf( '        Name: %s\n', SegmentName );
      
      % Get the segment parent
      SegmentParentName = MyClient.GetSegmentParentName( SubjectName, SegmentName ).SegmentName;
      %fprintf( '        Parent: %s\n',  SegmentParentName );

      % Get the segment's children
      ChildCount = MyClient.GetSegmentChildCount( SubjectName, SegmentName ).SegmentCount;
      %fprintf( '     Children (%d):\n', ChildCount );
      for ChildIndex = 1:ChildCount
        ChildName = MyClient.GetSegmentChildName( SubjectName, SegmentName, ChildIndex ).SegmentName;
       % fprintf( '       %s\n', ChildName );
      end% for  

      % Get the static segment translation
      Output_GetSegmentStaticTranslation = MyClient.GetSegmentStaticTranslation( SubjectName, SegmentName );
      fprintf( '        Static Translation: (%g, %g, %g)\n',                  ...
                         Output_GetSegmentStaticTranslation.Translation( 1 ), ...
                         Output_GetSegmentStaticTranslation.Translation( 2 ), ...
                         Output_GetSegmentStaticTranslation.Translation( 3 ) );
      
      % Get the static segment rotation in helical co-ordinates
      Output_GetSegmentStaticRotationHelical = MyClient.GetSegmentStaticRotationHelical( SubjectName, SegmentName );
      fprintf( '        Static Rotation Helical: (%g, %g, %g)\n',              ...
                         Output_GetSegmentStaticRotationHelical.Rotation( 1 ), ...
                         Output_GetSegmentStaticRotationHelical.Rotation( 2 ), ...
                         Output_GetSegmentStaticRotationHelical.Rotation( 3 ) );
      
      % Get the static segment rotation as a matrix
      Output_GetSegmentStaticRotationMatrix = MyClient.GetSegmentStaticRotationMatrix( SubjectName, SegmentName );
      fprintf( '        Static Rotation Matrix: (%g, %g, %g, %g, %g, %g, %g, %g, %g)\n', ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 1 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 2 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 3 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 4 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 5 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 6 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 7 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 8 ),            ...
                         Output_GetSegmentStaticRotationMatrix.Rotation( 9 ) );
      
      % Get the static segment rotation in quaternion co-ordinates
      Output_GetSegmentStaticRotationQuaternion = MyClient.GetSegmentStaticRotationQuaternion( SubjectName, SegmentName );
      fprintf( '        Static Rotation Quaternion: (%g, %g, %g, %g)\n',          ...
                         Output_GetSegmentStaticRotationQuaternion.Rotation( 1 ), ...
                         Output_GetSegmentStaticRotationQuaternion.Rotation( 2 ), ...
                         Output_GetSegmentStaticRotationQuaternion.Rotation( 3 ), ...
                         Output_GetSegmentStaticRotationQuaternion.Rotation( 4 ) );

      % Get the static segment rotation in EulerXYZ co-ordinates
      Output_GetSegmentStaticRotationEulerXYZ = MyClient.GetSegmentStaticRotationEulerXYZ( SubjectName, SegmentName );
      fprintf( '        Static Rotation EulerXYZ: (%g, %g, %g)\n',               ...
                         Output_GetSegmentStaticRotationEulerXYZ.Rotation( 1 ),  ...
                         Output_GetSegmentStaticRotationEulerXYZ.Rotation( 2 ),  ...
                         Output_GetSegmentStaticRotationEulerXYZ.Rotation( 3 ) );

      % Get the global segment translation
      Output_GetSegmentGlobalTranslation = MyClient.GetSegmentGlobalTranslation( SubjectName, SegmentName );
      fprintf( '        Global Translation: (%g, %g, %g) %s\n',               ...
                         Output_GetSegmentGlobalTranslation.Translation( 1 ), ...
                         Output_GetSegmentGlobalTranslation.Translation( 2 ), ...
                         Output_GetSegmentGlobalTranslation.Translation( 3 ), ...
                         AdaptBool( Output_GetSegmentGlobalTranslation.Occluded ) );
      globalposition(SubjectIndex)=Output_GetSegmentGlobalTranslation;
      
      % Get the global segment rotation in helical co-ordinates
      Output_GetSegmentGlobalRotationHelical = MyClient.GetSegmentGlobalRotationHelical( SubjectName, SegmentName );
      fprintf( '        Global Rotation Helical: (%g, %g, %g) %s\n',           ...
                         Output_GetSegmentGlobalRotationHelical.Rotation( 1 ), ...
                         Output_GetSegmentGlobalRotationHelical.Rotation( 2 ), ...
                         Output_GetSegmentGlobalRotationHelical.Rotation( 3 ), ...
                         AdaptBool( Output_GetSegmentGlobalRotationHelical.Occluded ) );
      
      % Get the global segment rotation as a matrix
      Output_GetSegmentGlobalRotationMatrix = MyClient.GetSegmentGlobalRotationMatrix( SubjectName, SegmentName );
      fprintf( '        Global Rotation Matrix: (%g, %g, %g, %g, %g, %g, %g, %g, %g) %s\n', ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 1 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 2 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 3 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 4 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 5 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 6 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 7 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 8 ),               ...
                         Output_GetSegmentGlobalRotationMatrix.Rotation( 9 ),               ...
                         AdaptBool( Output_GetSegmentGlobalRotationMatrix.Occluded ) );
      
      % Get the global segment rotation in quaternion co-ordinates
      Output_GetSegmentGlobalRotationQuaternion = MyClient.GetSegmentGlobalRotationQuaternion( SubjectName, SegmentName );
      fprintf( '        Global Rotation Quaternion: (%g, %g, %g, %g) %s\n',             ...
                         Output_GetSegmentGlobalRotationQuaternion.Rotation( 1 ),       ...
                         Output_GetSegmentGlobalRotationQuaternion.Rotation( 2 ),       ...
                         Output_GetSegmentGlobalRotationQuaternion.Rotation( 3 ),       ...
                         Output_GetSegmentGlobalRotationQuaternion.Rotation( 4 ),       ...
                         AdaptBool( Output_GetSegmentGlobalRotationQuaternion.Occluded ) );

      % Get the global segment rotation in EulerXYZ co-ordinates
      Output_GetSegmentGlobalRotationEulerXYZ = MyClient.GetSegmentGlobalRotationEulerXYZ( SubjectName, SegmentName );
      fprintf( '        Global Rotation EulerXYZ: (%g, %g, %g) %s\n',                 ...
                         Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 1 ),       ...
                         Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 2 ),       ...
                         Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 3 ),       ...
                         AdaptBool( Output_GetSegmentGlobalRotationEulerXYZ.Occluded ) );

      % Get the local segment translation
      Output_GetSegmentLocalTranslation = MyClient.GetSegmentLocalTranslation( SubjectName, SegmentName );
      fprintf( '        Local Translation: (%g, %g, %g) %s\n',               ...
                         Output_GetSegmentLocalTranslation.Translation( 1 ), ...
                         Output_GetSegmentLocalTranslation.Translation( 2 ), ...
                         Output_GetSegmentLocalTranslation.Translation( 3 ), ...
                         AdaptBool( Output_GetSegmentLocalTranslation.Occluded ) );
      
      % Get the local segment rotation in helical co-ordinates
      Output_GetSegmentLocalRotationHelical = MyClient.GetSegmentLocalRotationHelical( SubjectName, SegmentName );
      fprintf( '        Local Rotation Helical: (%g, %g, %g) %s\n',           ...
                         Output_GetSegmentLocalRotationHelical.Rotation( 1 ), ...
                         Output_GetSegmentLocalRotationHelical.Rotation( 2 ), ...
                         Output_GetSegmentLocalRotationHelical.Rotation( 3 ), ...
                         AdaptBool( Output_GetSegmentLocalRotationHelical.Occluded ) );
      
      % Get the local segment rotation as a matrix
      Output_GetSegmentLocalRotationMatrix = MyClient.GetSegmentLocalRotationMatrix( SubjectName, SegmentName );
      fprintf( '        Local Rotation Matrix: (%g, %g, %g, %g, %g, %g, %g, %g, %g) %s\n', ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 1 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 2 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 3 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 4 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 5 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 6 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 7 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 8 ),               ...
                         Output_GetSegmentLocalRotationMatrix.Rotation( 9 ),               ...
                         AdaptBool( Output_GetSegmentLocalRotationMatrix.Occluded ) );
      
      % Get the local segment rotation in quaternion co-ordinates
      Output_GetSegmentLocalRotationQuaternion = MyClient.GetSegmentLocalRotationQuaternion( SubjectName, SegmentName );
      fprintf( '        Local Rotation Quaternion: (%g, %g, %g, %g) %s\n',             ...
                         Output_GetSegmentLocalRotationQuaternion.Rotation( 1 ),       ...
                         Output_GetSegmentLocalRotationQuaternion.Rotation( 2 ),       ...
                         Output_GetSegmentLocalRotationQuaternion.Rotation( 3 ),       ...
                         Output_GetSegmentLocalRotationQuaternion.Rotation( 4 ),       ...
                         AdaptBool( Output_GetSegmentLocalRotationQuaternion.Occluded ) );

      % Get the local segment rotation in EulerXYZ co-ordinates
      Output_GetSegmentLocalRotationEulerXYZ = MyClient.GetSegmentLocalRotationEulerXYZ( SubjectName, SegmentName );
      fprintf( '        Local Rotation EulerXYZ: (%g, %g, %g) %s\n',                 ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 1 ),       ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 2 ),       ...
                         Output_GetSegmentLocalRotationEulerXYZ.Rotation( 3 ),       ...
                         AdaptBool( Output_GetSegmentLocalRotationEulerXYZ.Occluded ) );

    end% SegmentIndex

    % Get the quality of the subject (object) if supported
    Output_GetObjectQuality = MyClient.GetObjectQuality( SubjectName );
    if Output_GetObjectQuality.Result.Value == Result.Success
      fprintf( '    Quality: %g\n', Output_GetObjectQuality.Quality );
    end

    % Count the number of markers
    MarkerCount = MyClient.GetMarkerCount( SubjectName ).MarkerCount;
   % fprintf( '    Markers (%d):\n', MarkerCount );
    for MarkerIndex = 1:MarkerCount
      % Get the marker name
      MarkerName = MyClient.GetMarkerName( SubjectName, MarkerIndex ).MarkerName;

      % Get the marker parent
      MarkerParentName = MyClient.GetMarkerParentName( SubjectName, MarkerName ).SegmentName;

      % Get the global marker translation
      Output_GetMarkerGlobalTranslation = MyClient.GetMarkerGlobalTranslation( SubjectName, MarkerName );

      %fprintf( '      Marker #%d: %s (%g, %g, %g) %s\n',                     ...
                        % MarkerIndex - 1,                                    ...
                        % MarkerName,                                         ...
                        % Output_GetMarkerGlobalTranslation.Translation( 1 ), ...
                        % Output_GetMarkerGlobalTranslation.Translation( 2 ), ...
                        % Output_GetMarkerGlobalTranslation.Translation( 3 ), ...
                        % AdaptBool( Output_GetMarkerGlobalTranslation.Occluded ) );

      if bReadRays
        % Get the ray contributions for this marker
        Output_GetMarkerRayContributionCount = MyClient.GetMarkerRayContributionCount( SubjectName, MarkerName );
        if( Output_GetMarkerRayContributionCount.Result.Value == Result.Success )
          fprintf('      Contributed to by: ');

		  MarkerRayContributionCount = Output_GetMarkerRayContributionCount.RayContributionsCount;
          for ContributionIndex = 1: MarkerRayContributionCount
            Output_GetMarkerRayContribution = MyClient.GetMarkerRayContribution(SubjectName, MarkerName, ContributionIndex);
            fprintf( 'ID:%d Index:%d ', Output_GetMarkerRayContribution.CameraID, Output_GetMarkerRayContribution.CentroidIndex);
          end

          fprintf('\n' );
        end
      end% bReadRays
    end% MarkerIndex
    
  end% SubjectIndex

  % Get the unlabeled markers
  UnlabeledMarkerCount = MyClient.GetUnlabeledMarkerCount().MarkerCount;
  %fprintf( '  Unlabeled Markers (%d):\n', UnlabeledMarkerCount );
  for UnlabeledMarkerIndex = 1:UnlabeledMarkerCount
    % Get the global marker translation
    Output_GetUnlabeledMarkerGlobalTranslation = MyClient.GetUnlabeledMarkerGlobalTranslation( UnlabeledMarkerIndex );
    if bTrajectoryIDs
%       fprintf( '    Marker #%d: (%g, %g, %g): Traj ID %d\n',                                    ...
%                          UnlabeledMarkerIndex - 1,                                    ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 1 ), ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 2 ), ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 3 ), ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.MarkerID );
    else
%       fprintf( '    Marker #%d: (%g, %g, %g)\n',                                    ...
%                          UnlabeledMarkerIndex - 1,                                    ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 1 ), ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 2 ), ...
%                          Output_GetUnlabeledMarkerGlobalTranslation.Translation( 3 ) );
    end
  end% UnlabeledMarkerIndex

  % Get the labeled markers
  LabeledMarkerCount = MyClient.GetLabeledMarkerCount().MarkerCount;
 % fprintf( '  Labeled Markers (%d):\n', LabeledMarkerCount );
  for LabeledMarkerIndex = 1:LabeledMarkerCount
    % Get the global marker translation
    Output_GetLabeledMarkerGlobalTranslation = MyClient.GetLabeledMarkerGlobalTranslation( LabeledMarkerIndex );
    if bTrajectoryIDs
     % fprintf( '    Marker #%d: (%g, %g, %g): Traj ID %d\n',                                  ...
%                          LabeledMarkerIndex - 1,                                    ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 1 ), ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 2 ), ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 3 ), ...
%                          Output_GetLabeledMarkerGlobalTranslation.MarkerID );
    else
%       fprintf( '    Marker #%d: (%g, %g, %g)\n',                                  ...
%                          LabeledMarkerIndex - 1,                                    ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 1 ), ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 2 ), ...
%                          Output_GetLabeledMarkerGlobalTranslation.Translation( 3 ) );
    end
  end% LabeledMarkerIndex

  % Count the number of devices
  DeviceCount = MyClient.GetDeviceCount().DeviceCount;
  %fprintf( '  Devices (%d):\n', DeviceCount );
	
  for DeviceIndex = 1:DeviceCount
  
    %fprintf( '    Device #%d:\n', DeviceIndex - 1 );
    
    % Get the device name and type
    Output_GetDeviceName = MyClient.GetDeviceName( DeviceIndex );
    %fprintf( '      Name: %s\n', Output_GetDeviceName.DeviceName );
    %fprintf( '      Type: %s\n', Output_GetDeviceName.DeviceType.ToString() );

    % Count the number of device outputs
    DeviceOutputCount = MyClient.GetDeviceOutputCount( Output_GetDeviceName.DeviceName ).DeviceOutputCount;
    fprintf( '      Device Outputs (%d):\n', DeviceOutputCount );
    for DeviceOutputIndex = 1:DeviceOutputCount
      % Get the device output name and unit
      Output_GetDeviceOutputComponentName = MyClient.GetDeviceOutputComponentName( Output_GetDeviceName.DeviceName, DeviceOutputIndex );

      % Get the number of subsamples associated with this device.
      Output_GetDeviceOutputComponentSubsamples = MyClient.GetDeviceOutputComponentSubsamples( Output_GetDeviceName.DeviceName, Output_GetDeviceOutputComponentName.DeviceOutputName, Output_GetDeviceOutputComponentName.DeviceOutputComponentName );

      fprintf( '      Device Output #%d:\n', DeviceOutputIndex - 1 );

      fprintf( '      Samples (%d):\n', Output_GetDeviceOutputComponentSubsamples.DeviceOutputSubsamples );


      for DeviceOutputSubsample = 1:Output_GetDeviceOutputComponentSubsamples.DeviceOutputSubsamples
        fprintf( '        Sample #%d:\n', DeviceOutputSubsample - 1 );
        % Get the device output value
        Output_GetDeviceOutputComponentValue = MyClient.GetDeviceOutputComponentValue( Output_GetDeviceName.DeviceName, Output_GetDeviceOutputComponentName.DeviceOutputName, Output_GetDeviceOutputComponentName.DeviceOutputComponentName, DeviceOutputSubsample );

        fprintf( '          ''%s'' %g %s %s\n',                                    ...
                           Output_GetDeviceOutputComponentName.DeviceOutputName,            ...
                           Output_GetDeviceOutputComponentValue.Value,                      ...
                           Output_GetDeviceOutputComponentName.DeviceOutputUnit.ToString(), ...
                           AdaptBool( Output_GetDeviceOutputComponentValue.Occluded ) );
      end% DeviceOutputSubsample
    end% DeviceOutputIndex
    
  end% DeviceIndex
    
  % Count the number of force plates
  ForcePlateCount = MyClient.GetForcePlateCount().ForcePlateCount;
  %fprintf( '  Force Plates: (%d)\n', ForcePlateCount );
  for ForcePlateIndex = 1:ForcePlateCount
    fprintf( '    Force Plate #%d:\n', ForcePlateIndex - 1 );
    
    % Get the number of subsamples associated with this device.
    Output_GetForcePlateSubsamples = MyClient.GetForcePlateSubsamples( ForcePlateIndex );
    
    fprintf( '    Samples (%d):\n', Output_GetForcePlateSubsamples.ForcePlateSubsamples );
    for ForcePlateSubsample = 1:Output_GetForcePlateSubsamples.ForcePlateSubsamples
      % Output all the subsamples.
      fprintf( '      Sample #%d:\n', ForcePlateSubsample - 1 );
      
      Output_GetGlobalForceVector = MyClient.GetGlobalForceVector( ForcePlateIndex, ForcePlateSubsample );
      fprintf( '        Force (%g, %g, %g)\n',                           ...
                         Output_GetGlobalForceVector.ForceVector( 1 ), ...
                         Output_GetGlobalForceVector.ForceVector( 2 ), ...
                         Output_GetGlobalForceVector.ForceVector( 3 ) );
    
      Output_GetGlobalMomentVector = MyClient.GetGlobalMomentVector( ForcePlateIndex, ForcePlateSubsample );
      fprintf( '        Moment (%g, %g, %g)\n',                            ...
                         Output_GetGlobalMomentVector.MomentVector( 1 ), ...
                         Output_GetGlobalMomentVector.MomentVector( 2 ), ...
                         Output_GetGlobalMomentVector.MomentVector( 3 ) );
    
      Output_GetGlobalCentreOfPressure = MyClient.GetGlobalCentreOfPressure( ForcePlateIndex, ForcePlateSubsample );
      fprintf( '        CoP (%g, %g, %g)\n',                                       ...
                         Output_GetGlobalCentreOfPressure.CentreOfPressure( 1 ), ...
                         Output_GetGlobalCentreOfPressure.CentreOfPressure( 2 ), ...
                         Output_GetGlobalCentreOfPressure.CentreOfPressure( 3 ) );    
    end% ForcePlateSubsample                     
  end% ForcePlateIndex
  
  % Count the number of eye trackers
  EyeTrackerCount = MyClient.GetEyeTrackerCount().EyeTrackerCount;
  %fprintf( '  Eye Trackers: (%d)\n', EyeTrackerCount );
  for EyeTrackerIndex = 1:EyeTrackerCount
    fprintf( '    Eye Tracker #%d:\n', EyeTrackerIndex - 1 );

    Output_GetEyeTrackerGlobalPosition = MyClient.GetEyeTrackerGlobalPosition( EyeTrackerIndex );
    fprintf( '      Position (%g, %g, %g) %s\n',                       ...
                     Output_GetEyeTrackerGlobalPosition.Position( 1 ), ...
                     Output_GetEyeTrackerGlobalPosition.Position( 2 ), ...
                     Output_GetEyeTrackerGlobalPosition.Position( 3 ), ...
                     AdaptBool( Output_GetEyeTrackerGlobalPosition.Occluded ) );
   
    Output_GetEyeTrackerGlobalGazeVector = MyClient.GetEyeTrackerGlobalGazeVector( EyeTrackerIndex );
    fprintf( '      Gaze (%g, %g, %g) %s\n',                               ...
                     Output_GetEyeTrackerGlobalGazeVector.GazeVector( 1 ), ...
                     Output_GetEyeTrackerGlobalGazeVector.GazeVector( 2 ), ...
                     Output_GetEyeTrackerGlobalGazeVector.GazeVector( 3 ), ... 
                     AdaptBool( Output_GetEyeTrackerGlobalGazeVector.Occluded ) );
     
  end% EyeTrackerIndex  
    
  if bReadCentroids
    CameraCount = MyClient.GetCameraCount().CameraCount;
    fprintf( 'Cameras(%d):\n', CameraCount);

    for CameraIndex = 1:CameraCount
      fprintf('  Camera #%d:\n', CameraIndex - 1 );
        
      CameraName = MyClient.GetCameraName( CameraIndex ).CameraName;
      fprintf ( '    Name: %s\n', CameraName );

      fprintf( '    Id: %d\n', MyClient.GetCameraId( CameraName ).CameraId );
      fprintf( '    User Id: %d\n' , MyClient.GetCameraUserId( CameraName ).CameraUserId );
      fprintf('    Type: %s\n', MyClient.GetCameraType( CameraName ).CameraType);
      fprintf('    Display Name: %s\n', MyClient.GetCameraDisplayName( CameraName ).CameraDisplayName );
      Output_GetCameraResolution = MyClient.GetCameraResolution( CameraName );
      fprintf( '    Resolution: %d x %d\n' , Output_GetCameraResolution.ResolutionX , Output_GetCameraResolution.ResolutionY );
      if MyClient.GetIsVideoCamera( CameraName ).IsVideoCamera
        fprintf( '    Is Video Camera: true\n' );
      else
        fprintf( '    Is Video Camera: false\n' );
      end
      
      CentroidCount = MyClient.GetCentroidCount( CameraName ).CentroidCount;
      fprintf ( '    Centroids(%d):\n', CentroidCount );

      for CentroidIndex = 1:CentroidCount
        fprintf( '      Centroid #%d:\n', CentroidIndex - 1 );

        Output_GetCentroidPosition = MyClient.GetCentroidPosition( CameraName, CentroidIndex );
        fprintf( '        Position: (%g, %g)\n', Output_GetCentroidPosition.Position( 1 ), ...
                                                 Output_GetCentroidPosition.Position( 2 ) );
        fprintf( '        Radius: (%g)\n', Output_GetCentroidPosition.Radius );
        
        Output_GetCentroidWeight = MyClient.GetCentroidWeight( CameraName, CentroidIndex );
        if( Output_GetCentroidWeight.Result.Value == Result.Success )
          fprintf( '        Weighting: %g\n', Output_GetCentroidWeight.Weight );
        end %Output_GetCentroidWeight

      end% CentroidIndex
    end% CameraIndex
  end% bReadCentroids

%end% while true  