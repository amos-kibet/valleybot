run:
	./sh/run.sh $(mix_env)

debug:
	./sh/run.sh "$(mix_env)" "debug"

setup:
	./sh/setup.sh $(mix_env)

make release:
	./sh/release.sh

run.docker:
	./sh/run-docker.sh $(mix_env)

build:
	docker build -t valleybot .

docker.push:
	docker push valleybot