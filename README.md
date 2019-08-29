# gigablog
Source code for running the WordPress GigaBlog website

## Getting started

Download Trellis as a submodule:
```
$ git submodule init
$ git submodule update
```

Execute the generate_config.sh from the root directory of the repo:
```
$ ./ops/scripts/generate_config.sh
```

Go to the trellis directory and instantiate the VM using Vagrant:
```
$ cd trellis
$ vagrant up
```

Go to [http://gigablog.local](http://gigablog.local) on your web browser.