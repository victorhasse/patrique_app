# Contributing to patrique_app

Thank you for your interest in contributing to **patrique_app**! This document outlines the process and guidelines for contributing to this project.

---

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Branch Naming](#branch-naming)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)
- [Code Style](#code-style)
- [Code of Conduct](#code-of-conduct)

---

## Getting Started

1. **Fork** the repository on GitHub.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/your-username/patrique_app.git
   cd patrique_app
   ```
3. **Install dependencies** as described in the project README.
4. **Create a branch** for your changes (see [Branch Naming](#branch-naming)).

---

## How to Contribute

There are several ways to contribute to **patrique_app**:

- Fixing bugs
- Implementing new features
- Improving documentation
- Writing or improving tests
- Reviewing pull requests

---

## Branch Naming

Use the following naming convention for branches:

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feat/short-description` | `feat/user-authentication` |
| Bug fix | `fix/short-description` | `fix/login-crash` |
| Documentation | `docs/short-description` | `docs/update-readme` |
| Refactor | `refactor/short-description` | `refactor/auth-service` |
| Test | `test/short-description` | `test/add-unit-tests` |

---

## Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(optional scope): <short description>

[optional body]

[optional footer]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Examples:**
```
feat(auth): add social login with Google
fix(ui): resolve layout overflow on small screens
docs: update contributing guidelines
```

---

## Pull Request Process

1. Ensure your branch is up to date with `main` before opening a PR.
2. Fill in the pull request template completely.
3. Link any related issues using keywords (e.g., `Closes #42`).
4. Make sure all checks pass (lint, tests, build).
5. Request a review from the maintainer.
6. A pull request requires **at least one approval** before merging.
7. Squash commits when merging, if requested by the maintainer.

---

## Reporting Bugs

Before opening a bug report, please search existing issues to avoid duplicates.

When reporting a bug, include:

- A clear and descriptive title.
- Steps to reproduce the issue.
- Expected vs. actual behavior.
- Screenshots or logs, if applicable.
- Environment details (OS, browser/device, app version).

---

## Suggesting Features

Feature suggestions are welcome! Open an issue with the label `enhancement` and include:

- A clear description of the proposed feature.
- The motivation or use case behind it.
- Any alternatives you have considered.

---

## Code Style

- Follow the existing code conventions in the project.
- Ensure your code is properly formatted before submitting.
- Add comments where logic is non-obvious.
- Write tests for new functionality whenever applicable.

---

## Code of Conduct

By contributing, you agree to abide by our [Code of Conduct](./CODE_OF_CONDUCT.md). Please read it before participating.

---

We appreciate every contribution, no matter how small. Thank you for helping make **patrique_app** better!

---
---
# 🇧🇷 **Português** 🇧🇷

# Contribuindo com o patrique_app

Obrigado pelo seu interesse em contribuir com o **patrique_app**! Este documento descreve o processo e as diretrizes para contribuição neste projeto.

---

## Índice

- [Primeiros Passos](#primeiros-passos)
- [Como Contribuir](#como-contribuir)
- [Nomenclatura de Branches](#nomenclatura-de-branches)
- [Mensagens de Commit](#mensagens-de-commit)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Funcionalidades](#sugerindo-funcionalidades)
- [Estilo de Código](#estilo-de-código)
- [Código de Conduta](#código-de-conduta)

---

## Primeiros Passos

1. Faça um **fork** do repositório no GitHub.
2. **Clone** o fork localmente:
   ```bash
   git clone https://github.com/seu-usuario/patrique_app.git
   cd patrique_app
   ```
3. **Instale as dependências** conforme descrito no README do projeto.
4. **Crie uma branch** para suas alterações (veja [Nomenclatura de Branches](#nomenclatura-de-branches)).

---

## Como Contribuir

Existem diversas formas de contribuir com o **patrique_app**:

- Corrigindo bugs
- Implementando novas funcionalidades
- Melhorando a documentação
- Escrevendo ou aprimorando testes
- Revisando pull requests

---

## Nomenclatura de Branches

Utilize a seguinte convenção para nomear branches:

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Funcionalidade | `feat/descricao-curta` | `feat/autenticacao-usuario` |
| Correção de bug | `fix/descricao-curta` | `fix/crash-no-login` |
| Documentação | `docs/descricao-curta` | `docs/atualizar-readme` |
| Refatoração | `refactor/descricao-curta` | `refactor/servico-auth` |
| Testes | `test/descricao-curta` | `test/adicionar-testes-unitarios` |

---

## Mensagens de Commit

Siga a especificação [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>(escopo opcional): <descrição curta>

[corpo opcional]

[rodapé opcional]
```

**Tipos:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Exemplos:**
```
feat(auth): adicionar login social com Google
fix(ui): corrigir overflow de layout em telas pequenas
docs: atualizar diretrizes de contribuição
```

---

## Processo de Pull Request

1. Certifique-se de que sua branch está atualizada em relação à `main` antes de abrir um PR.
2. Preencha o template de pull request por completo.
3. Vincule issues relacionadas usando palavras-chave (ex.: `Closes #42`).
4. Verifique se todas as verificações passam (lint, testes, build).
5. Solicite a revisão do mantenedor.
6. Um pull request requer **pelo menos uma aprovação** antes de ser integrado.
7. Faça squash dos commits ao integrar, se solicitado pelo mantenedor.

---

## Reportando Bugs

Antes de abrir um relatório de bug, verifique as issues existentes para evitar duplicatas.

Ao reportar um bug, inclua:

- Um título claro e descritivo.
- Passos para reproduzir o problema.
- Comportamento esperado versus comportamento observado.
- Capturas de tela ou logs, se aplicável.
- Detalhes do ambiente (sistema operacional, navegador/dispositivo, versão do app).

---

## Sugerindo Funcionalidades

Sugestões de novas funcionalidades são bem-vindas! Abra uma issue com a label `enhancement` e inclua:

- Uma descrição clara da funcionalidade proposta.
- A motivação ou caso de uso por trás dela.
- Alternativas que você considerou.

---

## Estilo de Código

- Siga as convenções de código já existentes no projeto.
- Certifique-se de que seu código está devidamente formatado antes de submeter.
- Adicione comentários onde a lógica não for óbvia.
- Escreva testes para novas funcionalidades sempre que aplicável.

---

## Código de Conduta

Ao contribuir, você concorda em respeitar nosso [Código de Conduta](./CODIGO_DE_CONDUTA.md). Por favor, leia-o antes de participar.

---

Valorizamos cada contribuição, por menor que seja. Obrigado por ajudar a tornar o **patrique_app** ainda melhor!
