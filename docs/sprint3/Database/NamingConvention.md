## Database Naming Conventions

| Object Name               | Notation   | Plural | Abbreviation | Char Mask          | Underscores | Template |
|:--------------------------|:-----------|:-------|:-------------|:-------------------|:------------|:---------------|
| SQL Code Keywords           | UPPERCASE | N/A    | N/A           | [A-Z]         | N/A          | |
| Tables Name           | PascalCase | No    | No           | [A-z]         | No          | |
| **Attributes**              | camelCase | No     | Acronyms Only           | [A-z]         | No          | |
| Primary Keys (single)                |  |      |            |          |           | id | 
| Foreign Keys                |           |        |     |          |           | id**[TableName]** | 
| **Constraints**          | camelCase |   No   |    No        |   [A-z]    | Yes |
| Primary Keys               |  |     |     |         |         | pk_**[TableName]**_**[AttributeName]**
| Foreign Keys          |   |     |      |        |           | fk_**[TableName]**_**[AttributeName]**
| Unique           |   |     |      |         |           | un_**[TableName]**_**[AttributeName]**
| Check           |   |     |      |         |           | ck_**[TableName]**_**[AttributeName]**

