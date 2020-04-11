% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (C) OMG Plc 2009.
% All rights reserved.  This software is protected by copyright
% law and international treaties.  No part of this software / document
% may be reproduced or distributed in any form or by any means,
% whether transiently or incidentally to some other use of this software,
% without the written permission of the copyright owner.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part of the ViconDataStream SDK for MATLAB.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Result
  properties (Constant = true)
    Unknown                            = 0;
    NotImplemented                     = 1;
    Success                            = 2;
    InvalidHostName                    = 3;
    InvalidMulticastIP                 = 4;
    ClientAlreadyConnected             = 5;
    ClientConnectionFailed             = 6;
    ServerAlreadyTransmittingMulticast = 7;
    ServerNotTransmittingMulticast     = 8;
    NotConnected                       = 9;
    NoFrame                            = 10;
    InvalidIndex                       = 11;
    InvalidCameraName                  = 12;
    InvalidSubjectName                 = 13;
    InvalidSegmentName                 = 14;
    InvalidMarkerName                  = 15;
    InvalidDeviceName                  = 16;
    InvalidDeviceOutputName            = 17;
    InvalidLatencySampleName           = 18;
    CoLinearAxes                       = 19;
    LeftHandedAxes                     = 20;
    HapticAlreadySet                   = 21;
    EarlyDataRequested                 = 22, 
    LateDataRequested                  = 23,
    InvalidOperation                   = 24,
    NotSupported                       = 25,
    ConfigurationFailed                = 26,
    NotPresent                         = 27
  end
  
  properties
    Value
  end
  
  methods
    function obj = Result( value )
      obj.Value = value;
    end% Constructor
  end% methods
  
end% classdef
