#!/bin/sh 
$(tmux display-menu -T "#[align=centre fg=green]SSH to System" -x R -y P \
    "JCL1"  l   "send-keys \"ssh dylanf@pthjcl1.21csw.com.au\n\"" \
    "SCB1"  b   "send-keys \"ssh dylanf@pthscb1.21csw.com.au\n\"" \
    "SCH1"  h   "send-keys \"ssh dylanf@pthsch1.21csw.com.au\n\"" \
)
