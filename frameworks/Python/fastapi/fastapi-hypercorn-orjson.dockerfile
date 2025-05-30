FROM python:3.13

WORKDIR /fastapi

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install cython==3.0.12

COPY requirements.txt requirements-orjson.txt requirements-hypercorn.txt ./

RUN pip3 install -r requirements.txt -r requirements-orjson.txt -r requirements-hypercorn.txt

COPY . ./

EXPOSE 8080

CMD hypercorn app:app --bind 0.0.0.0:8080 --workers $(nproc)
