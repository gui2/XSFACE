function ch = GetCharInput

FlushEvents; 

global OSX_JAVA_GETCHAR;

% If no command line argument was passed we'll assume that the user only
% wants to get character data and timing/modifier data.
if nargin == 0
    getExtendedData = 1;
    getRawCode = 0;
elseif nargin == 1
    getRawCode = 0;
end

% This is Matlab. Is the Java VM and AWT and Desktop running?
if psychusejava('desktop')
    % Java virtual machine and AWT and Desktop are running. Use our Java based
    % GetChar.

    % Make sure that the GetCharJava class is loaded and registered with
    % the java focus manager.
    if isempty(OSX_JAVA_GETCHAR)
        try
            OSX_JAVA_GETCHAR = AssignGetCharJava;
        catch
            error('Could not load Java class GetCharJava! Read ''help PsychJavaTrouble'' for help.');
        end
        OSX_JAVA_GETCHAR.register;
    end

    % Make sure the Matlab window has keyboard focus:
    if exist('commandwindow') %#ok<EXIST>
        % Call builtin implementation:
        commandwindow;
    end

    % Loop until we receive character input.
    keepChecking = 1;
    while keepChecking
        % Check to see if a character is available, and stop looking if
        % we've found one.
        charValue = OSX_JAVA_GETCHAR.getChar;
        keepChecking = charValue == 0;
        if keepChecking
            drawnow;
        end
    end

    % Throw an error if we've exceeded the buffer size.
    if charValue == -1
        % Reenable keystroke dispatching to Matlab to leave us with a
        % functional Matlab console.
        OSX_JAVA_GETCHAR.setRedispatchFlag(0);
        error('GetChar buffer overflow. Use "FlushEvents" to clear error');
    end

    % Get the typed character.
    if getRawCode
        ch = charValue;
    else
        ch = char(charValue);
    end
    
    return;
else
    % Java VM unavailable, i.e., running in -nojvm mode.
    % On Windows, we can fall back to the old GetChar.dll, although we
    % only get info about typed characters, no 'when' extended data.
    if IsWin & ~IsOctave %#ok<AND2>
        % GetChar.dll has been renamed to GetCharNoJVM.dll. Call it.
        ch = GetCharNoJVM;
        when = [];
        return;
    end
end

% Either Octave or Matlab in No JVM mode on Linux or OS/X:

% Loop until we receive character input.
keepChecking = 1;
while keepChecking
    % Check to see if a character is available, and stop looking if
    % we've found one.

    % Screen's GetMouseHelper with command code 15 delivers
    % id of currently pending characters on stdin:
    charValue = Screen('GetMouseHelper', -15);
    keepChecking = charValue == 0;
    if keepChecking
        drawnow;
        if exist('fflush') %#ok<EXIST>
            builtin('fflush', 1);
        end
    end
end

% Throw an error if we've exceeded the buffer size.
if charValue == -1
    % Reenable keystroke display to leave us with a
    % functional console.
    Screen('GetMouseHelper', -11);
    error('GetChar buffer overflow. Use "FlushEvents" to clear error');
end

% Get the typed character.
if getRawCode
    ch = charValue;
else
    ch = char(charValue);
end

% No extended data in this mode:
when = [];

return;
