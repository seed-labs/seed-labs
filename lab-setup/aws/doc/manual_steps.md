Steps taken in addition to those in the src/seedvm-init.sh script to
create the AMI:

- Fix no-tab-autocomplete in terminal bug.   

1. Open Application Menu > Settings > Window Manager.    
2. Click on 'Keyboard' tab.   
3. Clear the 'Switch window for same application' setting.    
 _Credits_: instructions from
[here](https://askubuntu.com/questions/545540/terminal-autocomplete-doesnt-work-properly)
with bug confirmation
[here](https://www.starnet.com/xwin32kb/tab-key-not-working-when-using-xfce-desktop/)
.

- Remove the toolbar icon for Wireshark and create new one that's
a shortcut to wireshark-gtk .
