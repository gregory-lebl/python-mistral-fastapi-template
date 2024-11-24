#!/bin/bash

echo "Activation de l'environnement Python"
python3 -m venv venv && source ./venv/bin/activate

echo "Installation des dépendances Python"
pip install -r requirements.txt

echo "Récupération du LLM"
sudo apt install -y git-lfs
git lfs install
git clone https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.3
