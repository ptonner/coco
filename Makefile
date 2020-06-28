test:
	if [ "$$(ls -A tests/__pycache__/)" ]; then rm tests/__pycache__/*; fi
	pytest tests
