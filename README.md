### Docker image with Go for convert from any type of image to webp

Build
```shell
$ make build
```

Create `data` folder. This will handle input and output of the result
```shell
$ mkdir data
```

Run 
```shell
$ docker run --rm -e INPUT_FILE_NAME=hiho.png -e OUTPUT_FILE_NAME=hohi.webp -v /Users/wuriyanto/Documents/go-projects/gowebp/data/:/data gowebp
```