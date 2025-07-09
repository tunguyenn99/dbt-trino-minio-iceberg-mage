Deploy on another port because Trino took 8080

```bash
astro config set webserver.port 8080
```

or

```bash
astro config set -g webserver.port 8080
```

then 

```bash
astro dev start
```