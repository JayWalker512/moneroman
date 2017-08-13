Moneroman
=========

Ala, Monero Manager. This is a launcher script which allows changing the CPU 
usage of a process (for example, a crypto-currency mining program) when specific 
other processes are running, as specificed by a whitelist.
This is done by killing the managed process, and restarting it with the 
appropriate performance restrictions applied.

Configuring
===========

The script defines several variables which are used for configuration. You
will find them at the top of the `moneroman.sh` file with comments explaining use.

Moneroman.sh depends on the `cpulimit` command line utility, which you may need to install. On Ubuntu 16.04 you can install cpulimit with the `sudo apt install cpulimit` command.

Installing
==========

After you've configured the script, you can make it automatically start by using crontab. Open a terminal, and type `crontab -e` then at the bottom of the file add the following line:

`@reboot /path/to/moneroman.sh`

Then save the crontab. This will cause Moneroman to run every time you boot the computer (and login, if not installed as root).

Donating
========

If you find this script useful, I will graciously accept XMR tips at address:

4AJ7hzT7ULL6vNM7ChoQA1KPiWCaDA5zaCJVV2YJ4hE5HYh8NUZTcrg13qjW8Mm5F5ehGUE9oxJYvZUY3Xr5bP3K6uFqzXa

License
=======

Moneroman is licensed under the MIT license.
