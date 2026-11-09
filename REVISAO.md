# Revisão da atividade

## Resultados dos testes

| Comportamento verificado | Resultado |
| --- | --- |
| Nome formado apenas por espaços | Impedido com mensagem de preenchimento obrigatório |
| Quantidade negativa | Impedida com mensagem de número inteiro não negativo |
| Quantidade decimal | Impedida com mensagem de número inteiro não negativo |
| Cadastro de dois materiais | Registros são inseridos e a lista é atualizada após salvar |
| Edição de um material | Registro é atualizado pelo identificador e permanece salvo no SQLite |
| Cancelamento da exclusão | Registro é mantido quando a confirmação é cancelada |
| Exclusão de um material | Apenas o registro selecionado é removido |
| Situação do estoque | Quantidade zero retorna Sem estoque; abaixo do mínimo retorna Estoque baixo; igual ao mínimo retorna Estoque adequado |
| Nomes repetidos | São bloqueados sem diferença entre maiúsculas, minúsculas e espaços nas extremidades |

## Validação explicada

A validação de quantidade foi implementada no arquivo `lib/utils/validadores.dart`, no método `validarQuantidade`.

Esse arquivo reúne as regras que podem ser reutilizadas pelos campos do formulário. Dessa forma, a tela fica responsável por apresentar os dados e o validador fica responsável por decidir se o valor informado é aceito. O método rejeita campos vazios, letras, números negativos e valores decimais, aceitando somente inteiros maiores ou iguais a zero.
