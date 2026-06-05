# KNH Digital Infrastructure Project

This project simulates a hospital sensor monitoring system for Kenyatta National Hospital. A Python engine generates live data from 12 sensors across heart rate monitors, temperature sensors, and water meters. Three shell scripts handle the setup, analysis, and archiving of that data.

---

## Who Built What

| Member | Role | What they wrote |
|--------|------|-----------------|
| Member 1 | The Architect | Creates the folders the system needs to run |
| Member 2 | The Security Lead | Locks down the data folders so only the owner can access them |
| Member 3 | The Orchestrator | Ties M1 and M2 together and runs them in order |
| Member 4 | The Archivist | Moves old logs to storage and resets them so the engine keeps running |
| Member 5 | Clinical Analyst | Scans heart rate and temperature logs for critical readings |
| Member 6 | Facility Auditor | Calculates average ICU water usage and prints a summary |

---

## How to Run the Project

### Step 1 — Set up the environment
This creates the folders and secures permissions. Run it once before anything else.
```bash
chmod +x hospital_admin.sh hospital_analysis.sh hospital_archive.sh
./hospital_admin.sh
```

### Step 2 — Start the data engine
This starts generating live sensor data into the `active_logs` folder.
```bash
python3 hospital_system.py start
```
Give it a minute or two to build up some data before moving on.

### Step 3 — Analyse the data
This scans for critical heart rate and temperature readings, saves them to a report, and prints the ICU water usage summary.
```bash
./hospital_analysis.sh
```
Your critical alerts report will be saved to `reports/critical_alerts.txt`.

### Step 4 — Archive the logs
This moves the current logs to `archived_logs` with a timestamp and resets the active logs so the engine can keep recording.
```bash
./hospital_archive.sh
```

### Step 5 — Stop the engine when done
```bash
python3 hospital_system.py stop
```

---

## What the Logs Look Like

The engine writes one line per sensor reading, every second, in this format:

```
2026-06-05 14:23:01 | WARD_A_HR_01 | 123 | CRITICAL
```

| Column | Example | Meaning |
|--------|---------|---------|
| Timestamp | `2026-06-05 14:23:01` | When the reading was taken |
| Device ID | `WARD_A_HR_01` | Which sensor reported it |
| Value | `123` | The actual reading |
| Status | `CRITICAL` | NORMAL / WARNING / CRITICAL / HIGH_USAGE |

---

## Files in This Repo

```
Coding-lab_GroupXX/
├── hospital_system.py      The data engine — do not modify
├── hospital_admin.sh       Run first — sets up folders and permissions
├── hospital_analysis.sh    Run after the engine — finds critical readings
├── hospital_archive.sh     Run last — rotates and resets the logs
├── .gitignore              Keeps patient data off GitHub
└── README.md               You are here
```

---

## Important: What Gets Ignored by Git

Patient and sensor data must never be pushed to GitHub. The `.gitignore` file excludes:

- `active_logs/` — live sensor data
- `archived_logs/` — historical sensor data
- `reports/` — generated critical alert reports
- `/tmp/hospital_system.pid` — engine process file

If any of these folders appear in your GitHub repository, it counts as a data breach.

---

## Branching Strategy

Each member works on their own branch and merges into `main` when done.

```bash
git checkout -b logic-initialize    # Member 1
git checkout -b logic-security      # Member 2
git checkout -b logic-orchestrate   # Member 3
git checkout -b logic-archiving     # Member 4
git checkout -b logic-vitals        # Member 5
git checkout -b logic-water-audit   # Member 6
```

Every member should have at least 3 commits showing their own work before merging.
