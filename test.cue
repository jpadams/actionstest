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
					#returns tag without leading 'v' so "refs/tags/v0.0.1" returns "0.0.1"
					if [[ \#(client.env.GITHUB_REF) =~ "refs/tags/" ]]
					then
						echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/tags\/v//' | tr -d "[:space:]"
					#returns branch name, e.g. "main"
					elif [[ \#(client.env.GITHUB_REF) =~ "refs/heads/" ]]
					then
						echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/heads\///' | tr -d "[:space:]"
					#returns pull request number "refs/pull/1/merge" would return "1"
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
