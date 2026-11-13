# App de Pesquisa: 9ª Edição do Festival de Gastronomia e Cultura de Aracati

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Google Sheets](https://img.shields.io/badge/Google_Sheets-34A853?style=for-the-badge&logo=google-sheets&logoColor=white)

## Sobre o Projeto

Este aplicativo móvel foi desenvolvido exclusivamente para realizar a coleta de dados e pesquisas de satisfação durante a **9ª Edição do Festival de Gastronomia e Cultura de Aracati**. O sistema abrange dois públicos-alvo distintos do evento: **Visitantes** e **Empreendedores**.

**O Problema (A Motivação):**
Após observar a dinâmica e participar das edições anteriores do festival, identifiquei um gargalo logístico grave: **a conectividade**. Com a cidade lotada e milhares de pessoas concentradas no mesmo espaço físico, as redes móveis (3G/4G/5G) sofrem extrema instabilidade. Formulários online tradicionais (como Google Forms) falhavam constantemente, e o uso de papel gerava retrabalho massivo de tabulação, além do risco de perda de dados.

**A Solução:**
Desenvolvemos uma aplicação **Offline-First**. O aplicativo permite que a equipe de pesquisadores colete dados perfeitamente sem qualquer conexão com a internet. Assim que o dispositivo detecta uma rede estável, os dados são sincronizados automaticamente em segundo plano, utilizando uma arquitetura de redundância para garantir que nenhuma resposta seja perdida.

---

## Funcionalidades Principais

* **Coleta 100% Offline (Offline-First):** Todas as respostas são salvas imediatamente no armazenamento interno do celular (SQLite), garantindo zero dependência de internet no momento da pesquisa.
* **Sincronização em Nuvem (Tripla Redundância):** Quando há internet, o app envia os dados simultaneamente para duas plataformas:
  1. **Google Sheets:** Planilha em tempo real para a coordenação do evento acompanhar o andamento.
  2. **Supabase:** Banco de dados relacional robusto para análises complexas posteriores.
* **Exportação Manual de Emergência (CSV):** Caso o pesquisador termine o turno e não tenha acesso à internet, o app permite exportar as tabelas locais diretamente para arquivos `.csv` (Excel) no próprio celular, podendo ser enviados via WhatsApp ou cabo USB.
* **Identificação Dinâmica de Pesquisadores:** Lista suspensa (Dropdown) populada dinamicamente via variáveis de ambiente (`.env`), evitando erros de digitação nos e-mails dos aplicadores.
* **UI/UX Personalizada:** Interface focada na agilidade do trabalho de campo (formulários rápidos) e identidade visual imersiva com a marca do 9º Festival.

---

## Tecnologias e Arquitetura

* **Front-end:** Flutter & Dart (Visando compilação leve e rápida via APK).
* **Banco de Dados Local:** SQLite (Pacote `sqflite` para persistência offline).
* **Backend as a Service (BaaS):** Supabase (PostgreSQL via API).
* **Integração Externa:** Google Sheets API (via Google Cloud Console).
* **Monitoramento de Rede:** Pacote `connectivity_plus` para engatilhar a sincronização automática assim que a rede é restabelecida.

### Variáveis de Ambiente (`.env`)
O projeto utiliza o pacote `flutter_dotenv` para proteger chaves de API e isolar dados de configuração. Para rodar o projeto localmente, é necessário criar um arquivo `.env` na raiz seguindo o modelo:

```env
SUPABASE_URL=sua_url_aqui
SUPABASE_ANON_KEY=sua_chave_aqui
GOOGLE_SHEETS_CREDENTIALS=suas_credenciais_json_aqui
```

---

## Desenvolvimento e Distribuição

Devido às restrições de tempo e ambiente (necessidade de conta de desenvolvedor Apple e MacOS para compilação iOS), a estratégia de deploy foi focada em **Android (APK)**. O aplicativo foi compilado em modo Release (Fat APK) gerando um arquivo portátil que pode ser distribuído facilmente por aplicativos de mensagens (WhatsApp/Telegram) para os celulares dos pesquisadores do evento.

---
*Desenvolvido com Dart e Flutter no Ceará.*
