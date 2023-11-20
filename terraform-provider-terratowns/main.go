// package main: Declares the package name
// The main package is special in Go. It's where the execution of
// the program starts.
package main

// Imports the fmt package, which contains functions for formatted I/O.
import (
	"fmt"
	// "log"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"

)

// Defines the main function, the entry point of the application. When you
// run the program, it starts executing from this function. 
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	// Format Printline
	fmt.Println("This is AMAZING")
}

func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{

		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint for hte external service",
			},
			"token": {
				Type: schema.TypeString,
				Sensitive: true, //make the token sensitive to hide it in the logs
				Required: true,
				Description: "Bearer token for authorization",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID for configuration",
				// ValidateFunc: validateUUID
			},
		},
	}
	// p.ConfigureContextFunc = providerConfigure(p)
	return p
}

// func validateUUID(val interface{}, k string) (ws []string, errors []error) {
// 	log.Print('ValidateUUID:start')
// 	value := v.(string)
// 	if _,err = uuid.Parse(value); err != nil {
// 		errors = append(error, fmt.Errorf("invalid UUID format"))
// 	}
// 	log.Print('validateUUID:end')
// }
