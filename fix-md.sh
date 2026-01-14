#!/bin/bash
> README.md
pod2markdown < lib/Data/Tools.pm        >> README.md
pod2markdown < lib/Data/Tools/Socket.pm >> README.md
pod2markdown < lib/Data/Tools/Time.pm   >> README.md
pod2markdown < lib/Data/Tools/Math.pm   >> README.md
pod2markdown < lib/Data/Tools/CSV.pm              >> README.md
pod2markdown < lib/Data/Tools/Process/Forks.pm    >> README.md
