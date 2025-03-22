default: setup
setup:
	setup-magento-auth
	ddev setup
	import-db
	ddev magento deploy:mode:set developer
	ddev magerun setup:upgrade
	ddev import-db --file=db/base.sql.gz
setup-sample:
	ddev magento sampledata:deploy
	ddev magento setup:upgrade
