# Week 1 Guide: Session 1 (about 2 hours)
Goal for today: **the raw data is loaded into Snowflake, checked, and the project is on GitHub.**

| # | Step | Time |
|---|---|---|
| 1 | Kaggle: account, accept rules, download | 15 min |
| 2 | Snowflake account | 15 min |
| 3 | Put the files in place | 5 min |
| 4 | Run Part A (setup) | 10 min |
| 5 | Upload files to the stage | 10 min |
| 6 | Run Part B (load) | 10 min |
| 7 | Run Part C (reshape) | 15 min |
| 8 | Run Part D (checks) + fill the test log | 20 min |
| 9 | GitHub repo + first push | 15 min |
| — | Buffer | 5 min |

## 1. Kaggle (15 min)
1. Sign up or sign in at https://www.kaggle.com
2. Open https://www.kaggle.com/competitions/m5-forecasting-accuracy
3. Go to the **Rules** tab and click **I Understand and Accept**. (You can't download without this.)
4. Go to the **Data** tab and click **Download All**. You get a zip file.

## 2. Snowflake (15 min)
- Start a free trial at https://signup.snowflake.com. Pick **Enterprise** edition, cloud provider **Microsoft Azure**, region **West US 2 (Washington)**. The trial lasts 30 days with free credits and needs no payment card.
- Choosing Azure means Snowflake runs on Microsoft's cloud, so the project shows both names.
- ⚠️ The trial expires around Nov 26. That's logged as risk R1; the backup is DuckDB (free, runs on your laptop), and your Azure student account stays available for later.

## 3. Put the files in place (5 min)
Unzip. You only need **3 files**:
- `calendar.csv`
- `sell_prices.csv`
- `sales_train_evaluation.csv`

Move them into `digital_twin/projects/retail-data-trust-layer/data/`. That folder is excluded from GitHub on purpose: Kaggle data shouldn't be republished.

## 4. Run Part A (10 min)
1. In Snowsight, open **Projects » Workspaces** (or **Worksheets** on older accounts) and create a new **SQL** file.
2. Open `sql/01_setup_and_load.sql` from the project folder and paste the whole file in.
3. Select everything in **PART A** (from `USE ROLE` down to the `CREATE OR REPLACE TABLE SALES_LINES` statement) and press **Cmd+Enter**.
4. Every statement should succeed. If `USE ROLE SYSADMIN` fails, change it to `ACCOUNTADMIN` and rerun.

## 5. Upload files to the stage (10 min)
1. In Snowsight go to **Ingestion » Add Data » Load files into a Stage**.
2. Select the 3 CSV files.
3. Choose database **RETAIL_TRUST**, schema **RAW**, stage **M5_STAGE**. Leave the path empty.
4. Click **Upload**. (The limit is 250 MB per file; all three are under it.)

## 6. Run Part B (10 min)
Back in the worksheet, run `LIST @M5_STAGE;` and confirm all 3 files are there. Then run the three `COPY INTO` statements one at a time. Each result should say **LOADED** with **0 errors**.

## 7. Run Part C (15 min)
Run the `CREATE OR REPLACE TABLE SALES_DAILY` statement. It builds about 59 million rows and takes a few minutes. Read the comments while it runs: you need to be able to explain wide vs. long format in an interview.

## 8. Run Part D + fill the test log (20 min)
Run T1 through T10 one at a time. Open `docs/status/week1.md` and write the **actual** result next to each expected value. If anything doesn't match, don't fix it silently. Write it down; that's a finding, and it's exactly the trust story. Then run `ALTER WAREHOUSE RDT_WH SUSPEND;`.

## 9. GitHub (15 min)
1. Go to https://github.com/new. Name: `retail-data-trust-layer`. Public. Don't add a README (you already have one).
2. Open Terminal and run:
```bash
cd ~/Documents/digital_twin/projects/retail-data-trust-layer
git init
git status            # check: no .csv files or data/ folder should be listed
git add .
git commit -m "Week 1: project setup, Snowflake raw load and load checks"
git branch -M main
git remote add origin https://github.com/divyach357/retail-data-trust-layer.git
git push -u origin main
```
If `git status` shows any `.csv` files, stop and tell Claude before pushing.

## When you're done
Tell Claude your T1–T10 results, any errors, and which Snowflake account you used.
