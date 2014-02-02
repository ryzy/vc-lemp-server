# Check if command is present in the system (e.g. command?('rvm') to check if RVM is installed)
def command?(name)
  system("which #{name} > /dev/null 2>&1")
end
