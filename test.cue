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
				name: "sh"
				args: ["-c", "[[ \(client.env.GITHUB_REF) == \"refs/tags/\"* ]] && echo \(client.commands.version_pre.stdout) | sed -e 's/^v//'"]
				stdout: string
			}
		}
	}
	actions: {
		test: core.#Nop & {input: client.commands.version}
	}
}
