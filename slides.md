%   Формальное доказательство эквивалентности программ, скомпилированных в ABI
    со статическим и динамическим связыванием
%   Пьянкова Ю. А.\
    Научный руководитель: Малаховски Я. М.
%   17 июня 2015

---

# Введение

* Цена ошибки в программе пропорциональна:
    * частоте проявления,
    * сложности поиска,
    * сложности исправления.
* Вполне вероятно, что на данном этапе развития технологий не про все
  программы экономически целесообразно доказывать их корректность.
* Однако про инструменты разработки ПО уже давно целесообразно,
  поскольку сложность поиска и исправления ошибок в них чрезвычайно
  высоки, а многие полезные теоремы уже доказаны.

---

![](../images/diagram.png)

---

* S — изначальный язык программирования
* I — промежуточные языки, в которые транслируется код
* ASM — язык ассемблера
* opcode — машинный код
* .o — скомпилированные файлы с исполняемым кодом
* map mem — код, загруженный в память
* ld mem — пролинкованный код в памяти

---

![](../images/idealworld.png)

В идеальном мире диаграмма коммутативна: $t \circ o \equiv e \circ t$

---

# Идеальный компилятор

![](../images/idealcompiler.png)

---

![](../images/faith.png)

---

![](algebra.png)

$(g \circ f \equiv k \circ h) \to (m \circ k \equiv s \circ i)
\to (m \circ g \circ f \equiv s \circ i \circ h)$

---

* Выбор опкодов:
    * можно верифицировать, если иметь модель CPU;
* Генерация объектных файлов:
    * можно верифицировать, если формализовать формат ELF с его семантикой
      и реализовать доказанно корректный линковщик для него;
* Загрузка объектных файлов в память:
    * необходимо верифицированное ядро ОС;
    * верифицированные менеджеры памяти — большая открытая проблема;
* Техпроцесс:
    * можно только поверить.

---

# Существующие решения

* Software Foundations
    * учебник с формализациями простых исчислений и доказательств о них на Coq
* Iron Lambda
    * продолжение Software Foundations на реально использующиеся исчисления
    * доказаны все стандартные теоремы про все стандартные лямбда-исчисления
    * реально используется в компиляторе Disciple
* CompCert
    * компилятор подмножества C с доказанно корректными оптимизациями
* VeLLVM
    * транслятор SSA ассемблера с доказанно корректными оптимизациями

---

# CompCert

![](../images/compcert.png)

---

# VeLLVM

![](../images/vellvm.png)

---

# Цель работы

![](../images/ld.png)

---

# Цель работы

* Почему задача решаема:
    *   мы верим:
        *   соответствию ассемблера спецификации;
        *   корректности работы с объектными файлами;
        *   разработчикам ядра ОС;
        *   производителям CPU;
    *   не нужна работа с динамической памятью, что не требует решения
        больших открытых проблем.
* Проблемы:
    *   программы соответствуют некоторому ABI, и надо доказывать сохранение
        семантики линковщиком с точностью до заданного ABI;
    *   в области формальных доказательств существуют серьезные проблемы с
        переиспользованием доказательств для слегка измененных определений.

---

# Основные сущности и типы

*   Тип, значение которого может находиться в регистрах, и тип, описывающий
    состояние всех регистров:

\begin{code}%
\>\AgdaKeyword{data} \AgdaDatatype{RegType} \AgdaSymbol{:} \AgdaPrimitiveType{Set}\<%
\\
\>\AgdaFunction{RegTypes} \AgdaSymbol{=} \AgdaDatatype{List} \AgdaDatatype{RegType}\<%
\end{code}

*   Тип произвольного размера и тип, описывающий состояние памяти:

\begin{code}%
\>\AgdaKeyword{data} \AgdaDatatype{Type} \AgdaSymbol{:} \AgdaPrimitiveType{Set}\<%
\\
\>\AgdaFunction{DataType} \AgdaSymbol{=} \AgdaDatatype{List} \AgdaDatatype{Type}\<%
\end{code}

*   Стек вызовов и стек данных:

\begin{code}%
\>\AgdaFunction{DataStackType} \AgdaSymbol{=} \AgdaDatatype{List} \AgdaDatatype{RegType}\<%
\\
\>\AgdaFunction{CallStackType} \AgdaSymbol{=} \AgdaDatatype{List} \AgdaSymbol{(}\AgdaFunction{RegTypes} \AgdaFunction{×} \AgdaFunction{DataStackType}\AgdaSymbol{)}\<%
\end{code}

---

# Основные сущности и типы

*   Типы данных:

\begin{code}%
\>\AgdaKeyword{data} \AgdaDatatype{RegType} \AgdaKeyword{where}\<%
\\
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaInductiveConstructor{\_*} \<[6]%
\>[6]\AgdaSymbol{:} \AgdaDatatype{Type} \AgdaSymbol{→} \AgdaDatatype{RegType}\<%
\\
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaInductiveConstructor{int} \AgdaSymbol{:} \AgdaDatatype{RegType}\<%
\end{code}

\begin{code}%
\>\AgdaKeyword{data} \AgdaDatatype{Type} \AgdaKeyword{where}\<%
\\
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaInductiveConstructor{atom} \AgdaSymbol{:} \AgdaDatatype{RegType} \AgdaSymbol{→} \AgdaDatatype{Type}\<%
\\
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaInductiveConstructor{block} \AgdaSymbol{:} \AgdaFunction{RegTypes}\<%
\\
\>[2]\AgdaIndent{8}{}\<[8]%
\>[8]\AgdaSymbol{→} \AgdaFunction{DataStackType}\<%
\\
\>[2]\AgdaIndent{8}{}\<[8]%
\>[8]\AgdaSymbol{→} \AgdaFunction{CallStackType}\<%
\\
\>[2]\AgdaIndent{8}{}\<[8]%
\>[8]\AgdaSymbol{→} \AgdaDatatype{Type}\<%
\end{code}

---

# Инструкции

*   Управляющая инструкция:

\begin{code}%
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaKeyword{data} \AgdaDatatype{ControlInstr} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{)}\<%
\\
\>[2]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{:} \AgdaDatatype{Maybe} \AgdaSymbol{(}\AgdaFunction{CallStackChg} \AgdaBound{S}\AgdaSymbol{)} \AgdaSymbol{→} \AgdaPrimitiveType{Set}\<%
\end{code}

*   Не-управляющая инструкция:

\begin{code}
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaKeyword{data} \AgdaDatatype{Instr} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{)} \AgdaSymbol{:} \AgdaDatatype{SmallChg} \AgdaBound{S} \AgdaSymbol{→} \AgdaPrimitiveType{Set}\<%
\end{code}

---

# Мета-ассемблер

*   Обычно при небольшом изменении основных определений все доказательства приходится
    менять
*   Общую для всех языков ассемблера часть можно определить независимо от
    конкретного языка ассемблера

\begin{code}%
\>[0]\AgdaIndent{2}{}\<[2]%
\>[2]\AgdaKeyword{module} \AgdaModule{Blocks}\<%
\\
\>[2]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaSymbol{(}\AgdaBound{ControlInstr} \AgdaSymbol{:} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{18}{}\<[18]%
\>[18]\AgdaSymbol{→} \AgdaDatatype{Maybe} \AgdaSymbol{(}\AgdaFunction{CallStackChg} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{18}{}\<[18]%
\>[18]\AgdaSymbol{→} \AgdaPrimitiveType{Set}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaSymbol{(}\AgdaBound{Instr} \AgdaSymbol{:} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{)} \AgdaSymbol{→} \AgdaDatatype{SmallChg} \AgdaBound{S} \AgdaSymbol{→} \AgdaPrimitiveType{Set}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaKeyword{where}\<%
\\
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaKeyword{data} \AgdaDatatype{Block} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{)} \AgdaSymbol{:} \AgdaRecord{Diff} \AgdaBound{S} \AgdaSymbol{→} \AgdaPrimitiveType{Set}\<%
\end{code}

<!---
хотелось бы показать, что еще есть exec-block, но у всех exec-* очень
страшные сигнатуры
-->

---

# Мета-ассемблер

*   Определения, относящиеся к мета-ассемблеру, можно получать по
    минимальному описанию конкретного языка ассемблера:
    
    *   тип управляющей инструкции;
    *   тип не-управляющей инструкции;
    *   функция, определяющая результат исполнения управляющей инструкции;
    *   функция, определяющая результат исполнения не-управляющей инструкции.

---

# Ассемблер: примеры инструкций

*   Непрямой `jmp`:

\begin{code}
\>[4]\AgdaInductiveConstructor{jmp[\_]} \AgdaSymbol{:} \AgdaSymbol{(}\AgdaBound{ptr} \AgdaSymbol{:} \AgdaInductiveConstructor{atom}\<%
\\
\>[4]\AgdaIndent{11}{}\<[11]%
\>[11]\AgdaSymbol{(}\AgdaInductiveConstructor{block}\<%
\\
\>[4]\AgdaIndent{11}{}\<[11]%
\>[11]\AgdaSymbol{(}\AgdaField{StateType.registers} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{11}{}\<[11]%
\>[11]\AgdaSymbol{(}\AgdaField{StateType.datastack} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{11}{}\<[11]%
\>[11]\AgdaSymbol{(}\AgdaField{StateType.callstack} \AgdaBound{S}\AgdaSymbol{)} \AgdaInductiveConstructor{*}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{11}{}\<[11]%
\>[11]\AgdaFunction{∈} \AgdaField{StateType.memory} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{9}{}\<[9]%
\>[9]\AgdaSymbol{→} \AgdaDatatype{ControlInstr} \AgdaBound{S} \AgdaInductiveConstructor{nothing}\<%
\end{code}

*   `push` значения из регистра:

\begin{code}
\>[4]\AgdaInductiveConstructor{push} \AgdaSymbol{:} \AgdaSymbol{∀} \AgdaSymbol{\{}\AgdaBound{r}\AgdaSymbol{\}}\<%
\\
\>[4]\AgdaIndent{9}{}\<[9]%
\>[9]\AgdaSymbol{→} \AgdaBound{r} \AgdaFunction{∈} \AgdaField{StateType.registers} \AgdaBound{S}\<%
\\
\>[4]\AgdaIndent{9}{}\<[9]%
\>[9]\AgdaSymbol{→} \AgdaDatatype{Instr} \AgdaBound{S} \AgdaSymbol{(}\AgdaInductiveConstructor{onlystack} \AgdaSymbol{(}\AgdaInductiveConstructor{StackDiff.push} \AgdaBound{r}\AgdaSymbol{))}\<%
\end{code}

---

# Линковка

*   При динамической линковке в память добавляются таблицы GOT и PLT:

\begin{code}%
\>[2]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaFunction{pltize} \AgdaSymbol{:} \AgdaFunction{DataType} \AgdaSymbol{→} \AgdaFunction{DataType}\<%
\end{code}

*   Элемент таблицы PLT выглядит следующим образом:

\begin{code}%
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaFunction{plt-stub} \AgdaSymbol{:} \AgdaSymbol{∀} \AgdaSymbol{\{}\AgdaBound{R} \AgdaBound{H} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{\}} \AgdaSymbol{→} \AgdaInductiveConstructor{atom} \AgdaSymbol{(}\AgdaInductiveConstructor{block} \AgdaBound{R} \AgdaBound{DS} \AgdaBound{CS} \AgdaInductiveConstructor{*}\AgdaSymbol{)} \AgdaFunction{∈} \AgdaBound{H}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaSymbol{→} \AgdaDatatype{Block} \AgdaSymbol{(}\AgdaInductiveConstructor{statetype} \AgdaBound{R} \AgdaBound{H} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{)} \AgdaFunction{dempty}\<%
\\
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaFunction{plt-stub} \AgdaBound{got} \AgdaSymbol{=} \AgdaInductiveConstructor{↝} \AgdaInductiveConstructor{jmp[} \AgdaBound{got} \AgdaInductiveConstructor{]}\<%
\end{code}

---

# Леммы

*   Состояние исполнителя в момент непосредственного вызова функции
    эквивалентно состоянию исполнителя после исполнения непрямого `jmp`
    по указателю на ее тело:

\begin{code}%
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaSymbol{∀} \AgdaSymbol{\{}\AgdaBound{ST}\AgdaSymbol{\}} \AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{State} \AgdaBound{ST}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{14}{}\<[14]%
\>[14]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{p} \AgdaSymbol{:} \AgdaInductiveConstructor{atom} \AgdaSymbol{(}\AgdaInductiveConstructor{block}\<%
\\
\>[14]\AgdaIndent{19}{}\<[19]%
\>[19]\AgdaSymbol{(}\AgdaField{StateType.registers} \AgdaBound{ST}\AgdaSymbol{)}\<%
\\
\>[14]\AgdaIndent{19}{}\<[19]%
\>[19]\AgdaSymbol{(}\AgdaField{StateType.datastack} \AgdaBound{ST}\AgdaSymbol{)}\<%
\\
\>[14]\AgdaIndent{19}{}\<[19]%
\>[19]\AgdaSymbol{(}\AgdaField{StateType.callstack} \AgdaBound{ST}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{17}{}\<[17]%
\>[17]\AgdaInductiveConstructor{*}\AgdaSymbol{)} \AgdaFunction{∈} \AgdaField{StateType.memory} \AgdaBound{ST}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{14}{}\<[14]%
\>[14]\AgdaSymbol{→} \AgdaFunction{exec-block} \AgdaBound{S} \AgdaSymbol{(}\AgdaInductiveConstructor{↝} \AgdaInductiveConstructor{jmp[} \AgdaBound{p} \AgdaInductiveConstructor{]}\AgdaSymbol{)}\<%
\\
\>[0]\AgdaIndent{14}{}\<[14]%
\>[14]\AgdaDatatype{≡} \AgdaBound{S}\<%
\\
\>[0]\AgdaIndent{14}{}\<[14]%
\>[14]\AgdaInductiveConstructor{,} \AgdaFunction{loadblock}\<%
\\
\>[14]\AgdaIndent{16}{}\<[16]%
\>[16]\AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[14]\AgdaIndent{16}{}\<[16]%
\>[16]\AgdaSymbol{(}\AgdaFunction{loadptr} \AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)} \AgdaBound{p}\AgdaSymbol{)}\<%
\end{code}

---

# Леммы

*   Состояние исполнителя в момент непосредственного вызова функции
    эквивалентно состоянию исполнителя после исполнения соответствующего
    этой функции элемента PLT при условии корректно заполненного GOT:

\begin{code}%
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaSymbol{∀} \AgdaSymbol{\{}\AgdaBound{R} \AgdaBound{H} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{\}}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{f} \AgdaSymbol{:} \AgdaInductiveConstructor{block} \AgdaBound{R} \AgdaBound{DS} \AgdaBound{CS} \AgdaFunction{∈} \AgdaBound{H}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{State} \AgdaSymbol{(}\AgdaInductiveConstructor{statetype} \AgdaBound{R} \AgdaSymbol{(}\AgdaFunction{pltize} \AgdaBound{H}\AgdaSymbol{)} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{))}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaSymbol{→} \AgdaFunction{GOT[} \AgdaBound{f} \AgdaFunction{]-correctness} \AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaSymbol{→} \AgdaFunction{exec-block} \AgdaBound{S} \AgdaSymbol{(}\AgdaFunction{plt-stub} \AgdaSymbol{(}\AgdaFunction{got} \AgdaBound{f}\AgdaSymbol{))}\<%
\\
\>[4]\AgdaIndent{13}{}\<[13]%
\>[13]\AgdaDatatype{≡} \AgdaBound{S} \AgdaInductiveConstructor{,} \AgdaFunction{loadblock} \AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)} \AgdaSymbol{(}\AgdaFunction{func} \AgdaBound{f}\AgdaSymbol{)}\<%
\end{code}

---

# Эквивалентность блоков

*   Блок $A$ в состоянии исполнителя $S_1$ и блок $B$ в состоянии
    исполнителя $S_2$ считаются эквивалентными, если конструктивно
    существует блок $C$ в состоянии исполнителя $S_C$, достижимый из $A$ в
    состоянии $S_1$ и из $B$ в состоянии $S_2$ (частный случай
    bisimulation).

\begin{code}%
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaKeyword{data} \AgdaDatatype{BlockEq}\<%
\\
\>[4]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{:} \AgdaSymbol{\{}\AgdaBound{ST₁} \AgdaBound{ST₂} \AgdaSymbol{:} \AgdaRecord{StateType}\AgdaSymbol{\}}\<%
\\
\>[4]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{→} \AgdaSymbol{\{}\AgdaBound{d₁} \AgdaSymbol{:} \AgdaRecord{Diff} \AgdaBound{ST₁}\AgdaSymbol{\}} \AgdaSymbol{\{}\AgdaBound{d₂} \AgdaSymbol{:} \AgdaRecord{Diff} \AgdaBound{ST₂}\AgdaSymbol{\}}\<%
\\
\>[4]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{S₁} \AgdaSymbol{:} \AgdaRecord{State} \AgdaBound{ST₁}\AgdaSymbol{)} \AgdaSymbol{(}\AgdaBound{S₂} \AgdaSymbol{:} \AgdaRecord{State} \AgdaBound{ST₂}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{A} \AgdaSymbol{:} \AgdaBound{Block} \AgdaBound{ST₁} \AgdaBound{d₁}\AgdaSymbol{)} \AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{B} \AgdaSymbol{:} \AgdaBound{Block} \AgdaBound{ST₂} \AgdaBound{d₂}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{6}{}\<[6]%
\>[6]\AgdaSymbol{→} \AgdaPrimitiveType{Set}\<%
\end{code}

---

# Эквивалентность программ

*   Программа $A$ — набор блоков памяти, подмножеством которого является набор
    блоков кода, среди которых указан стартовый блок $main_A$
*   Две программы $A$ и $B$ считаются эквивалентными, если для любого
    корректного состояния исполнителя $S_{start}$ эквивалентны $main_A$ в
    состоянии $S_{start}$ и $main_B$ в состоянии $S_{start}$
*   Отношение bisimulation является отношением
    эквивалентности, следовательно, подстановочным. Тогда если для
    любого состояния $S$ блок $A$ эквивалентен блоку $B$, то замена блока
    $A$ на блок $B$ в программе не влияет на результат исполнения.

---

# Теорема

*   При корректно заполненном GOT верна внешняя эквивалентность блока PLT,
    использующего соответствующий функции элемент GOT, и самой функции:

\begin{code}%
\>[0]\AgdaIndent{4}{}\<[4]%
\>[4]\AgdaSymbol{∀} \AgdaSymbol{\{}\AgdaBound{R} \AgdaBound{H} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{\}}\<%
\\
\>[4]\AgdaIndent{10}{}\<[10]%
\>[10]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{f} \AgdaSymbol{:} \AgdaInductiveConstructor{block} \AgdaBound{R} \AgdaBound{DS} \AgdaBound{CS} \AgdaFunction{∈} \AgdaBound{H}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{10}{}\<[10]%
\>[10]\AgdaSymbol{→} \AgdaSymbol{(}\AgdaBound{S} \AgdaSymbol{:} \AgdaRecord{State} \AgdaSymbol{(}\AgdaInductiveConstructor{statetype} \AgdaBound{R} \AgdaSymbol{(}\AgdaFunction{pltize} \AgdaBound{H}\AgdaSymbol{)} \AgdaBound{DS} \AgdaBound{CS}\AgdaSymbol{))}\<%
\\
\>[4]\AgdaIndent{10}{}\<[10]%
\>[10]\AgdaSymbol{→} \AgdaFunction{GOT[} \AgdaBound{f} \AgdaFunction{]-correctness} \AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)}\<%
\\
\>[4]\AgdaIndent{10}{}\<[10]%
\>[10]\AgdaSymbol{→} \AgdaDatatype{BlockEq} \AgdaBound{S} \AgdaBound{S}\<%
\\
\>[10]\AgdaIndent{12}{}\<[12]%
\>[12]\AgdaSymbol{(}\AgdaFunction{plt-stub} \AgdaSymbol{(}\AgdaFunction{got} \AgdaBound{f}\AgdaSymbol{))}\<%
\\
\>[10]\AgdaIndent{12}{}\<[12]%
\>[12]\AgdaSymbol{(}\AgdaField{proj₂} \AgdaFunction{\$} \AgdaFunction{loadblock} \AgdaSymbol{(}\AgdaField{State.memory} \AgdaBound{S}\AgdaSymbol{)} \AgdaSymbol{(}\AgdaFunction{func} \AgdaBound{f}\AgdaSymbol{))}\<%
\end{code}

---

# Эквивалентность программ, слинкованных статически и динамически

*   В предположении, что добавление новых элементов в релоцируемый код не
    изменяет семантику программы, эквивалентны:
    *   оригинальная программа (статически слинкованная программа);
    *   программа с добавленными таблицами GOT и PLT;
    *   программа с добавленными таблицами GOT и PLT с
        заменой вызовов функций на вызовы соответствующих элементов PLT.
*   Последний пункт после загрузки в память по определению является
    динамически слинкованной программой с точностью до перестановки данных,
    расположенных в памяти.

---

# Результаты

*   Реализован фреймворк (мета-ассемблер), обобщающий определения основных
    сущностей и эквивалентности блоков для различных языков ассемблера.

*   Формализовано подмножество ассемблера x86_64 на базовых блоках со стеком и
    типизированной статической памятью:

    * подмножество, необходимое для описания элементов PLT;
    * основные управляющие инструкции, совершающие безусловные переходы;
    * загрузка значения из памяти в регистр;
    * основные инструкции, работающие со стеком данных.

*   Формализовано подмножество ABI, касающееся компоновки со статическим и
    динамическим связыванием.

---

# Результаты

*   Доказана (интенсиональная) эквивалентность состояний исполнителя в момент
    непосредственного вызова функции и после исполнения непрямого `jmp` по
    указателю на тело функции
*   Доказана (интенсиональная) эквивалентность состояний исполнителя в момент
    непосредственного вызова функции и после исполнения соответствующего этой
    функции элемента PLT при условии корректно заполненного GOT
*   Доказана внешняя эквивалентность (эквивалентность вызовов) некоторой
    функции и соответствующего ей элемента PLT при условии корректно
    заполненного GOT
*   В указанном ранее предположении доказана эквивалентность статически и
    динамически слинкованных программ

---

\Huge Вопросы?
