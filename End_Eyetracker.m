function End_Eyetracker

    WaitSecs(0.1);
    % stop the recording of eye-movements for the current trial
    Eyelink('StopRecording');
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    Eyelink('ShutDown');  
    
end
