on run {input, parameters}
    # Must use full path.
    set cmd to "/usr/local/bin/nvim "
    set filepaths to ""
    if input is not {} then
      repeat with currentFile in input
        set filepaths to filepaths & quoted form of POSIX path of currentFile & " "
      end repeat
    end if
    tell application "System Events" to set terminalIsRunning to exists application process "Terminal"
    tell application "Terminal"
      activate
      if terminalIsRunning is true then
        do script with command cmd & filepaths
      else
        do script with command cmd & filepaths in window 1
      end if
    end tell
end run
