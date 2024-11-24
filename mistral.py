from mistral_inference.model import Transformer
from mistral_inference.generate import generate
from mistral_common.tokens.tokenizers.mistral import MistralTokenizer
from mistral_common.protocol.instruct.messages import UserMessage, SystemMessage
from mistral_common.protocol.instruct.request import ChatCompletionRequest
from pathlib import Path
from Prompt import Prompt


def generate_text_with_mistral(prompt: Prompt):
    mistral_models_path = Path.cwd().joinpath("Mistral-7B-Instruct-v0.3")

    tokenizer = MistralTokenizer.from_file(
        f"{mistral_models_path}/tokenizer.model.v3")

    model = Transformer.from_folder(mistral_models_path)

    completion_request = ChatCompletionRequest(messages=[SystemMessage(
        content="You are a pirate chatbot who always responds in pirate speak!"), UserMessage(content=prompt.message), ])

    tokens = tokenizer.encode_chat_completion(completion_request).tokens

    out_tokens, _ = generate([tokens], model, max_tokens=256, temperature=0.0,
                             eos_id=tokenizer.instruct_tokenizer.tokenizer.eos_id)

    result = tokenizer.instruct_tokenizer.tokenizer.decode(out_tokens[0])

    print(result)
    return result
