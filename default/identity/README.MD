The files in this directory are templates that will be copied to `../identity/` .

The `req_header_header.conf` doesn't actually have anything to do with identity.
It's actually a header that gets merged with the distinguished name (identity),
and the further merged with individual signing requests by the scripts.

If you want to edit your identity then don't edit the files here and run `../identify.sh` instead.
