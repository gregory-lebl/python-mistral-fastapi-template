from typing import Union
from fastapi import FastAPI
from Prompt import Prompt
from mistral import generate_text_with_mistral

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/llm")
def llm(prompt: Prompt):
    if prompt.message:
        response = generate_text_with_mistral(prompt.message)
        return {"message": response}
    else:
        return {"error": "Le prompt est null"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
