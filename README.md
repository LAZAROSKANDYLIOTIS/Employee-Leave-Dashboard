# Human Resources: Employee Leave Dashboard

This ABAP project provides an interactive **Employee Leave Dashboard** built entirely using both **Old and New ABAP Syntax**, showcasing advanced usage of the **CL\_SALV\_TABLE** class , **event handling**, and **OpenSQL data retrieval**.

The user interacts with a **custom selection screen** to find each employee's leave data, and the results are presented in an ALV grid with features such as sorting, column renaming, absence day aggregation, and double-click navigation to item-level leave details.

---

## 📋 Main Program

`zprg_hr_empleave.prog.abap`

---

## 🧩 Simulated Data Model

This project simulates core fields from **standard SAP HR tables** like `PA0001`, `PA2001`, and customizes the descriptive table for absence types.

## 📊 Data Sources and Field Mapping

### Custom Tables Used:

1. **ZHREMPLOYEES** (simulates PA0001)

   | Field | Description        |
   | ----- | ------------------ |
   | PERNR | Personnel Number   |
   | ENAME | Employee Full Name |

2. **ZHRABSENCES** (simulates PA2001)
   \| Field   | Description                       |
   \| PERNR   | Personnel Number (FK)             |
   \| BEGDA   | Absence Start Date                |
   \| ENDDA   | Absence End Date                  |
   \| AWART   | Absence Type Code                 |
   \| ABWTG   | Absence Days (Quantitative value) |
   \| REMARKS | Additional Notes                  |

3. **ZHRABSENCETYPES** (simulates T554S)

   | Field | Description               |
   | ----- | ------------------------- |
   | AWART | Absence Type Code (PK/FK) |
   | ATEXT | Absence Type Description  |
   | SPRAS | Language Key              |

---

## 🔗 Key Relationships

* **ZHREMPLOYEES.PERNR = ZHRABSENCES.PERNR**

  > Links each employee with their absence records.

* **ZHRABSENCES.AWART = ZHRABSENCETYPES.AWART**

  > Used to retrieve the human-readable absence description (`ATEXT`) based on the code.

---


