FROM golang:1.22.5 as base

WORKDIR /app

#dependency files
COPY go.mod .  

#download all dependency
RUN go mod download

#copy the app code
COPY . .

#Build the go application
RUN go build -o main .

#using multistage with distroless image to reduce image size and security
FROM gcr.io/distroless/base

#copy the base binary to distro
COPY --from=base /app/main .

#copying static files along with binary
COPY --from=base /app/static ./static

EXPOSE 8080

CMD [ "./main" ]

