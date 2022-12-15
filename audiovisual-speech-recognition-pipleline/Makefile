build:
	@docker build -t jupyter_octave:1.0 .

serve:
	@docker container run --rm \
		-p 8888:8888 \
		--user root \
		-e NB_GID=100 \
		-v $(PWD)/work:/home/jovyan/work \
		-it --name jupyter_octave jupyter_octave:1.0 \