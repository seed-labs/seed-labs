# Configuration That Requires Manual Efforts

Most of the steps in VM building are automated in our 
building scripts. There are still two things that need to be 
done manually (until we find ways to automate them).


## Disable the system upgrade reminder

Once the VM is built, we do not want the VM to be updated,
because it may break some labs. The OS will keep
reminding us about upgrading. We can disable the 
reminder. Run ```update-manager``` in terminal, go to ```Settings```,
change the settings for "automatically check for updates"
and "notify of new Ubuntu version" to ```Never```. 
[[Reference]](https://askubuntu.com/questions/218755/how-to-disable-the-update-manager-popup/218780#218780)


## Fix Ubuntu internal error problem

We always get a notification from OS saying that there is
an internal error. This is really nothing serious.
To disable the notification, we need to do two steps
[[Reference]](https://www.youtube.com/watch?v=w7FEA1N11jo):

- Go to ```Settings``` --> ```Privacy``` --> ```Diagnostics```, and
  change "Send error report to Canonical" to ```Never```.

- Change ```/etc/default/apport```, set ```enabled=0``` 
  (the original value was 1; this step is actually done automatically in our 
  script, so you will see that the value is already changed to 0)

## Install HTTP header live extension 

We need to manually install the "HTTP Header Live" extension, because 
most of the web secrutiy labs need it. 


## Disable DNS Over HTTPS

 In Version 80.0.1, Firefox uses DNS over HTTPS, which no longer uses the
```/etc/hosts``` file. We need to disable it.
Click the menu button and select ```Preferences```.
In the ```General``` panel, scroll down to ```Network Settings``` 
and click the ```Settings``` button.
In the dialog box that opens, scroll down to "Enable DNS over HTTPS", and disable it.
