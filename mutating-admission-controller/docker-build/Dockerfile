
FROM python:3.8-alpine

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 443

CMD ["python", "main.py"]