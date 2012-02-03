# PHP Log Monitor 

PHP Log Monitor is like it's name says a monitor of the PHP error Log.

I like to develop monitoring the php log with tail, so whenever a error comes, i'm able to quickly see whats wrong and the *Stack trace* (if you have the php **xdebug** extension).  
That does work, but often happens (at least to me) that the console isn't at the front of the applications (it also happens quite often even with two monitors).  
That's why i wanted a way to whenever a error appears (Fatal error, Parse error, Deprecated, Warning or Notice) being able to quickly see it in my screen.

## Getting Started

## Installation

1. Download the Zip file from [here](https://github.com/titosemi/phplog-monitor/zipball/master)

	or clone the git repository to wherever you like (if you don't know where **/opt** is usually a good place):  
	```
	git clone git://github.com/titosemi/phplog-monitor.git /opt
	```

2. Make the script executable:  

	```
	chmod +x /opt/phplog-monitor/phplog-monitor.sh
	```

3. Create a symbolic link to your $PATH (if you are not sure what this is about just make it to **/usr/bin**):  

	```
	ln -s ln -s /opt/phplog-monitor/phplog-monitor.sh /usr/bin/phplog-monitor
	```

## Usage

### Running the script
Just type in your command line

```
phplog-monitor
```

### Help
if you want to see the options type
  
```
phplog-monitor --help  
```  
or  
```
phplog-monitor -h  
```  
or  
```
phplog-monitor --usage  
```

That's up to your flavour :)


### Specify the Log file
```
phplog-monitor --log=/var/log/apache2/my_virtualhost.tld.error.php
```

### Being verbose
```
phplog-monitor --verbose
```

### Debug
```
phplog-monitor --debug
```

---

Of course you can run some of them at the same time  

```
phplog-monitor --verbose --log=/var/log/apache2/my_virtualhost.tld.error.php
```

### Getting your first error notifications

### Tips


## Features

* ### Autoload of php log
	It will try to autoload the php log from some common places if no log file is specified.

* ### Verbose function
	It will print (in the console/terminal) every line added to the php log

## Requeriments and Compatibility

At the moment and since i develop on mac, it just support osx notifications because i don’t have any linux box with a graphical ui installed.
But it can be easily extensible to other notificators.

### Systems
1. osx (tested on Lion 10.7.2)

### Notificators
1. osx
	1. Growl (tested with 1.2.2)

## License

Apache License, Version 2.0

Copyright (c) 2012 Josemi Liébana, [http://josemi-liebana.com](http://josemi-liebana.com)

For the full copyright and license information, please view the License file that was distributed with this source code.



## Credits

Icons: Joaquín Labayen Cirujano, [http://sehacendisenos.com](http://sehacendisenos.com)