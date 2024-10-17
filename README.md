# Final Project Presentation - NHL Game Data Analysis
This is a final group project as part of the Junior Data Engineer Program by Generation SG, in collaboration with Temasek Polytechnic and Microsoft. The goal of this project was to build an ETL/ELT pipeline to ingest data into a PostgreSQL server and perform data analysis, providing strategic recommendations based on the insights. Microsoft Azure services such as Azure Data Lake Gen2, Azure Data Factory, Azure Databricks and Azure Database PostgreSQL were used.  

  
**Dataset Source:** 
>[NHL Game Data on Kaggle](https://www.kaggle.com/martinellis/nhl-game-data)
  
**Project Documents:**
>[Project Documentation](https://github.com/JDE-2024/NHL_project/blob/main/docs/JDE2024%20-%20Nexus%20Nucleus%20Final%20Project%20Report.pdf)

>[Presentation](https://github.com/JDE-2024/NHL_project/blob/main/docs/JDE2024-NHL-Finalproject.pdf)
 
 

## Objectives

  

**Data Engineering:** Build an effective, scalable ETL pipeline for NHL data, encompassing the following stages:

-  **Ingest**

-  **Transform**

-  **Load**

  

**Data Analysis:**

1.  **X-Y Coordinate Analysis:** Propose the best attack angles, distances, and shot types with the highest probability of scoring goals in the rink.

2.  **Dream Team Analysis:** Identify and propose a "Dream Team" of 23 non-playable characters (NPCs) based on historical performance, consisting of 12 forwards, 8 defensemen, and 3 goalies.

  

## Methodology (ETL)

  

![ETL Pipeline](https://github.com/JDE-2024/NHL_project/blob/main/images/git-img-archi.png)

  

### Approach

  

1.  **Data Extraction:**

- Using Azure Data Factory (ADF), we extracted the data from Kaggle as a ZIP file and unzipped it, loading the CSV files into our **Bronze** layer.

  

2.  **Data Transformation:**

- We utilized Databricks notebooks to clean and transform the data across layers.

- In the **Silver** layer, we removed duplicates and handled null values. In the **Gold** layer, we applied transformations tailored for analysis, such as new column calculations.

- We used PySpark for larger datasets and Pandas for smaller ones. Data in the Silver and Gold layers were stored as Delta format files, leveraging Parquet for optimized performance and providing benefits like version control and ACID transactions.

  

3.  **Data Loading:**

- The transformed data was uploaded into PostgreSQL using Databricks notebooks.

  

4.  **Data Orchestration:**

- ADF orchestrated the pipeline, ensuring that tasks were executed sequentially. Monitoring tools within ADF helped track pipeline execution, identify errors, and verify successes or failures.

  

5.  **Analysis & Visualization:**

- We connected Power BI and Jupyter Notebooks to the PostgreSQL database for final data exploration and visualization.

  

## Database ERD

  

![Database ERD](https://github.com/JDE-2024/NHL_project/blob/main/images/git-img-erd.png)

  

## X-Y Coordinate Analysis

  

The team aimed to answer the following questions:

- Which positions on the rink are most likely to result in a goal?

- What types of shots are most effective based on distance and angle from the goal post?

  

### Transformations:

- Transposed the x-y coordinates to one side of the rink.

- Set the goal position at x=89.

- Assumed all shots were within x=0 to 89.

- Created new features: Angle, Distance, Angle-Group, Distance-Group.

- Formulated a composite index for goal probability.

  

### Findings:

-  **Shot Types and Distance:**

-  **0 to 25 ft:** Tip-In and Backhand

-  **25 to 50 ft:** Snap Shot

-  **50 to 75 ft:** Slap Shot

-  **Shot Types and Angles:**

-  **0 to 30°:** Tip-In

-  **50 to 90° / -50 to -90°:** Wrap Around

- Wrist Shot was versatile, effective across a wide range of distances and angles.

-  **Key Insight:** Distance plays a larger role in shot success than angle.

  

## NPC Dream Team

  

Identified the top 23 players (under 26 years old), categorized into three groups based on recorded performance using a composite score out of 10, weighted by specific metrics.

  

-  **12 Forwards:**

- Goals: 3 pts

- Shots: 3 pts

- Assists: 1 pt

- Time on Ice: 3 pts

-  **8 Defensemen:**

- Takeaways: 3 pts

- Blocked Shots: 3 pts

- Assists: 1 pt

- Time on Ice: 3 pts

-  **3 Goalies:**

- Saves: 7 pts

- Time on Ice: 3 pts