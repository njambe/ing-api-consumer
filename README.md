# INSERT TITLE HERE

## How-to

1. Login on https://developer.ing.com with GitHub account
1. Create an app
1. Subscribe to the Showcase API
1. Run generate_certs.sh to generate both certificates pairs (2 x <public,private>)
1. Go to the app page and paste certificates (server_public.crt)
  * HTTPS Request Signing --> http_sign/server_public.crt
  * Mutual TLS --> tls_mutual/server_public.crt
1. Wait for the subscrpition to be approved (manual process, may take time)
1. Write your own client ID in the file clientid (file has to be created)
1. Run oauth_token.sh to get an OAuth token from ING server
1. Run showcase_api.sh to call the Showcase API
