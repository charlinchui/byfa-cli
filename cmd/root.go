/*
Copyright © 2024 CARLOS BUENO COIG-O'DONNEL CARLOSBUENO038@GMAIL.COM
*/
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "byfa",
	Short: "BYFA is a simple CLI made to scaffold basic API projects",
	Long: `BYFA stands for Build Your First API, it aims to help developers learning a new language or framework scaffolding their first API project with it.
We currently support: Express.
We aim to support: Express, Go (net/http), NestJS, Rust (TBD) & FastAPI on the first release. 
It is an open source project, we accept contributions at: <link>`,
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
