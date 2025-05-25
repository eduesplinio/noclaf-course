# NoclafApp - App iOS com SwiftUI

Este projeto é um aplicativo iOS desenvolvido em SwiftUI que demonstra a implementação de autenticação de usuários e gerenciamento de perfil.

## Funcionalidades

- Autenticação de usuários
- Gerenciamento de perfil
- Feed de conteúdo
- Navegação por tabs
- Persistência de dados
- Tratamento de erros
- Interface responsiva

## Requisitos

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- CocoaPods

## Dependências

- Alamofire: Para requisições HTTP
- SwiftHash: Para geração de hash MD5

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/NoclafApp.git
```

2. Instale as dependências:
```bash
cd NoclafApp
pod install
```

3. Abra o arquivo `NoclafApp.xcworkspace` no Xcode

4. Execute o projeto (⌘R)

## Estrutura do Projeto

```
NoclafApp/
├── Models/
│   ├── API/
│   │   └── UserModel.swift
│   └── DAO/
│       └── UserDAO.swift
├── Views/
│   ├── Authentication/
│   │   └── LoginComponents/
│   │       ├── ButtonView.swift
│   │       ├── LogoView.swift
│   │       ├── TextView.swift
│   │       └── TitleView.swift
│   ├── Main/
│   │   ├── FeedView.swift
│   │   └── ProfileView.swift
│   └── TabNavView.swift
└── README.md
```

## Uso

### Autenticação

```swift
UserDAO.shared.authenticate(username: "usuario@email.com", password: "senha") { result in
    switch result {
    case .success(let response):
        // Login bem-sucedido
    case .failure(let error):
        // Tratar erro
    }
}
```

### Obter Dados do Usuário

```swift
UserDAO.shared.getUser { result in
    switch result {
    case .success(let response):
        if let user = response.user {
            // Usar dados do usuário
        }
    case .failure(let error):
        // Tratar erro
    }
}
```

## Arquitetura

O projeto segue uma arquitetura MVVM (Model-View-ViewModel) com algumas adaptações:

- **Models**: Contém as estruturas de dados e DAOs
- **Views**: Implementa a interface do usuário
- **DAOs**: Gerencia a comunicação com a API

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Contato

Seu Nome - [@seu_twitter](https://twitter.com/seu_twitter) - email@exemplo.com

Link do Projeto: [https://github.com/seu-usuario/NoclafApp](https://github.com/seu-usuario/NoclafApp) 