# README

In case of:  
>  FATAL: Listen error: unable to monitor directories for changes.

after the first time you run `bin/rails s`, you will have to increase a number of file watchers!

You can get your current inotify file watch limit by executing:  
`$ cat /proc/sys/fs/inotify/max_user_watches`

You can set a new limit temporary with:  
`$ sudo sysctl fs.inotify.max_user_watches=524288`  
`$ sudo sysctl -p`

As seen on this [Github Page] (link does not open in new tab!)

[Github Page]: <https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers#the-technical-details>
