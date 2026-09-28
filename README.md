## 💊 Pharmacy Sales Analysis (Star Schema)

تحليل مبيعات صيدليات أوروبية على قاعدة بيانات بنظام **Star Schema**: جدول حقائق (`FactSales`) و3 جداول أبعاد (`DimDate`, `DimPharmacy`, `DimProduct`).

| البند | التفاصيل |
|---|---|
| **حجم البيانات** | 62,139 عملية بيع، 120 صيدلية، 8 دول |
| **المصدر** | [European Pharmacy Sales Dataset](https://www.kaggle.com/datasets/ehmadali/eu-pharmacy-products-and-pricing) |
| **الحلول الكاملة** | [`SQL_Pharmacy_Project_Solutions.md`](./SQL_Pharmacy_Project_Solutions.md) |

**أبرز الأسئلة:**
- إجمالي الإيرادات والوحدات المباعة، والإيراد لكل دولة وفئة منتجات
- الاتجاه الشهري للإيرادات ونسبة المبيعات اللي عليها عروض
- مقارنة الهامش الربحي بين المنتجات الجنيسة والمنتجات ذات العلامة التجارية
- المنتجات المباعة في دولة ومش في دولة تانية (`EXCEPT`)، والصيدليات اللي بتبيع فئتين مع بعض (`INTERSECT`)

**المفاهيم:** `Star Schema` · `Multiple JOINs` · `CASE WHEN` · `CAST` · `Set Operators`
