# certloop
A certificate checker tool with dynamic discovery (when possible)

## Route53
Login with your AWS credentials and run:
```
./route53.sh
```

## File list
Google domains is not exposing APIs, so you have to export a file list:
save it to a local file, one entry per line:

```
cat /my/file/list.txt

www.example.org
example.org
foo.example.org
bar.example.org
```

then run:
```
./simple_list.sh /my/file/list.txt
```

## Azure DNS
Login to your Azure DNS account and run:
```
./azure_dns.sh
```
