from typing import Union
from fastapi import FastAPI
from dto.Prompt import Prompt
from mistral import generate_text_with_mistral

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/llm")
def llm(prompt: Prompt):
    if prompt.message:
        response = generate_text_with_mistral(prompt)
        return {"message": response}
    else:
        return {"error": "Le prompt est null"}
