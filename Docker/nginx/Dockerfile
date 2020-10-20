FROM nginx:alpine

RUN apk --no-cache update  && apk --no-cache upgrade 
COPY nginx.conf /etc/nginx/
COPY index.html /usr/share/nginx/html/ 
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

