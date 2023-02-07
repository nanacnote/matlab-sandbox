build:
	@docker build -t computer-vision-workflow:latest .

serve:
	@docker container run --rm \
		-d \
		-p 8888:8888 \
		--user root \
		-e NB_GID=100 \
		-v $(PWD)/work:/home/jovyan/work \
		-it --name computer-vision-workflow computer-vision-workflow:latest \