package test

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: {
		env: {
			GITHUB_REF: string
		}
		commands: {
			version: {
				name: "bash"
				args: ["-c", #"""
					set -e
					if [[ \#(client.env.GITHUB_REF) =~ "refs/tags/" ]]
					then
						echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/tags\/v//' | tr -d "[:space:]"
					elif [[ \#(client.env.GITHUB_REF) =~ "refs/heads/" ]]
					then
						echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/heads\///' | tr -d "[:space:]"
					elif [[ \#(client.env.GITHUB_REF) =~ "refs/pull/" ]]
					then
						echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/pull\///;s/\/merge$//' | tr -d "[:space:]"
					fi
					"""#]
			}
		}
	}
	actions: {
		test: core.#Nop & {input: client.commands.version.stdout}
	}
}
