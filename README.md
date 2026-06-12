# Coding-lab_Group35 — KNH Digital Infrastructure

Kenyatta National Hospital data management and analysis system built with Shell Scripting.

## Group Roles

| Member | Role | Script | Contribution |
|--------|------|--------|-------------|
| 1 | The Architect | `hospital_admin.sh` | `initialize_system()` — creates directory structure |
| 2 | The Security Lead | `hospital_admin.sh` | `secure_data()` — sets file permissions |
| 3 | The Orchestrator | `hospital_admin.sh` | Execution logic — calls M1 and M2 in order |
| 4 | The Archivist | `hospital_archive.sh` | `archive_logs()` — rotates logs with timestamps |
| 5 | Clinical Analyst | `hospital_analysis.sh` | `process_vitals()` — filters CRITICAL alerts |
| 6 | Facility Auditor | `hospital_analysis.sh` | `water_audit()` — calculates ICU water averages |

## Instructions

### Start the data engine
```bash
python3 hospital_system.py start
```

### Stop the data engine
```bash
python3 hospital_system.py stop
```

### Initialize and secure the environment
```bash
bash hospital_admin.sh
```

### Archive active logs
```bash
bash hospital_archive.sh
```

### Run analysis and generate reports
```bash
bash hospital_analysis.sh
```

## System Architecture

- **12 sensors**: 5 Heart Rate, 5 Temperature, 2 Water Usage
- Logs stored in `active_logs/`, archived in `archived_logs/`
- Reports saved to `reports/critical_alerts.txt`
