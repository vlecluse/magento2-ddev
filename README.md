# DDEV Example for Magento 2
This repo is a demonstration of how to use a Magento 2 repository on ddev
## Installation
If you have docker and ddev installed properly, and have your Magento Repository username and password

```
git clone git@github.com:vlecluse/magento2-ddev.git
cd magento2-ddev
ddev setup
```
## Start
To start the containers
```
ddev start
```

## Stop
To stop the containers
```
ddev stop
```


This will prompte you for your Magento Repository username and password and save it in a auth.json file

## Sample Data
If you want to have sample magento data

```
ddev magento sampledata:deploy
ddev magento setup:upgrade
```
