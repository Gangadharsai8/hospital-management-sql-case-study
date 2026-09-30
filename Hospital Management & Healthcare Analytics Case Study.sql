create database case_study;
use case_study;
show databases;
show tables;

select * from appointments; -- appointment_id,patient_id,doctor_id
select * from billing; -- bill id,pateint_id , treatment_id
select * from doctors; -- doctor id
select * from patients; -- patient id
select * from treatments; -- treatment_id,appointment_id

-- data profiling
SELECT 'patients' AS table_name, COUNT(*) AS record_count FROM patients
UNION ALL
SELECT 'doctors', COUNT(*) FROM doctors -- total docters
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments -- total appointments
UNION ALL
SELECT 'treatments', COUNT(*) FROM treatments -- total treatments
UNION ALL
SELECT 'billing', COUNT(*) FROM billing; -- total billings

select * from appointments;
select status, count(*) as appointment_count from appointments group by status;
/* hospital should follow 
   send appointment reminders 
   investegating on cancellation
   Completed appointments are fewer compared to scheduled ones, suggesting gaps between booking and actual visits.
   */
   
select year(registration_date) as year, month(registration_date) as month ,
count(*) as patient_count from patients
group by year,month
order by year,month;
/*
Patient registrations are spread unevenly across months, indicating irregular acquisition patterns.
Certain months (e.g., Sep 2021, Sep 2022, Apr & Jun 2023) show relatively higher registrations, suggesting periodic demand spikes.
*/

SELECT DISTINCT specialization FROM doctors;
-- Limited specialization variety suggests potential scope to expand services based on patient demand and future growth plans.

-- patients without appointment
SELECT COUNT(*) AS patients_without_appointments
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;
/* wo patients are registered in the system but have not scheduled any appointments, indicating potential early-stage drop-off.
This may reflect incomplete onboarding, lack of follow-up, or data entry gaps.
Targeted reminders or follow-up communication could help convert these registrations into active visits.
*/

-- treatment cost range
SELECT
  MIN(cost) AS min_cost,
  MAX(cost) AS max_cost,
  AVG(cost) AS avg_cost
FROM treatments;
/* Treatment costs range from low-cost procedures (~534) to high-cost treatments (~4,974), showing a wide cost variation.
The average treatment cost (~2,756) indicates a balanced mix of routine and specialized medical services. */

-- payment status 
SELECT payment_status, COUNT(*) AS bill_count
FROM billing
GROUP BY payment_status;
/* A significant number of bills are marked as Pending and Failed, indicating cash flow risks and payment collection challenges.
The number of Paid bills is relatively low compared to total billing records, impacting realized revenue.
improving payment follow-ups and resolving failed transactions can significantly enhance financial stability.
*/

-- billing amount statistics 
SELECT
  MIN(amount) AS min_bill,
  MAX(amount) AS max_bill,
  AVG(amount) AS avg_bill
FROM billing;
/* The minimum, maximum, and average bill amounts closely align with the observed treatment cost range, indicating billing values are consistent with treatment pricing.
The similarity between average treatment cost and average bill amount suggests that treatments are being accurately translated into billing records.
No extreme anomalies are observed, implying overall billing integrity, though individual record-level checks may still be required.
*/

-- Patient distribution by address
SELECT address, COUNT(*) AS patient_count
FROM patients
GROUP BY address
ORDER BY patient_count DESC;
/* Certain addresses (e.g., 321 Maple Dr, 789 Pine Dr) have a high concentration of patients, indicating localized demand.
Repeated patient registrations from the same addresses suggest strong referral networks or residential clusters.
These locations can be prioritized for targeted outreach, home-care services, or awareness programs. */

-- Doctor Specialization Demand
SELECT
  d.specialization,
  COUNT(a.appointment_id) AS total_appointments
FROM appointments a
JOIN doctors d
  ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY total_appointments DESC;
/* Pediatrics has the highest appointment volume, indicating it is the most in-demand specialization.
Dermatology also shows strong demand, while Oncology has comparatively fewer appointments.
High-demand specializations may require additional staffing or extended clinic hours, whereas lower-demand areas can be evaluated for capacity optimization. */

-- Treatment ↔ Billing Gap Analysis (Revenue Leakage Check)
SELECT
  t.treatment_id,
  t.appointment_id,
  t.treatment_type,
  t.cost,
  t.treatment_date
FROM treatments t
LEFT JOIN billing b
  ON t.treatment_id = b.treatment_id
WHERE b.bill_id IS NULL;
/* All treatments in the dataset have corresponding billing records, indicating no revenue leakage.
This reflects a well-integrated treatment and billing workflow within the hospital.
Strong alignment between clinical services and billing improves financial accuracy and audit readiness. */

--  total revenue generated
SELECT
  SUM(amount) AS total_revenue
FROM billing
WHERE payment_status = 'Paid';
/* The hospital has generated a total realized revenue of ₹173,424.90, considering only successfully paid bills.
This figure represents the hospital’s actual cash inflow, excluding pending and failed payments. */

--  Payment Risk Analysis
SELECT
  payment_status,
  COUNT(*) AS bill_count,
  SUM(amount) AS total_amount
FROM billing
GROUP BY payment_status;
/* A significant portion of billing value lies under Pending (₹184,612) and Failed (₹193,212.94) payments, indicating high unrealized revenue.
Although ₹173,424.90 has been successfully collected, unpaid amounts exceed paid revenue, posing a cash flow and collection risk.
Strengthening payment follow-ups and resolving failed transactions can substantially improve revenue realization. */

-- Payment Failure Risk Analysis
SELECT
  COUNT(*) AS failed_bill_count,
  SUM(amount) AS failed_amount
FROM billing
WHERE payment_status = 'Failed';
/* 67 failed payments amounting to ₹193,212.94 represent a significant unrealized revenue risk.
Failed payments account for a large share of total billed value, directly impacting cash flow.
Addressing payment failures through retry mechanisms, patient follow-ups, or alternate payment options can quickly improve revenue without increasing patient volume. */

-- Rank Doctors by Total Appointments (Top Performers)
SELECT
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  d.specialization,
  COUNT(a.appointment_id) AS total_appointments
FROM doctors d
JOIN appointments a
  ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, doctor_name, d.specialization
ORDER BY total_appointments DESC LIMIT 5;
/* Sarah Taylor (Dermatology) leads with the highest number of appointments, indicating strong patient demand and high utilization.
Dermatology and Pediatrics dominate the top performers list, confirming these as high-demand specializations.
The concentration of appointments among a few doctors suggests a need for workload balancing to prevent burnout and maintain care quality.
*/

-- Rank Treatments by Frequency
SELECT
  treatment_type,
  COUNT(*) AS treatment_count,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS frequency_rank
FROM treatments
GROUP BY treatment_type;
/* Chemotherapy is the most frequently performed treatment, indicating a high oncology workload.
X-Ray and ECG follow closely, highlighting strong demand for diagnostic services.
MRI and Physiotherapy share similar frequencies, suggesting balanced utilization and opportunities for capacity optimization. */

 -- Monthly Revenue Trend
 SELECT
  YEAR(bill_date) AS year,
  MONTH(bill_date) AS month,
  SUM(amount) AS total_revenue
FROM billing
WHERE payment_status = 'Paid'
GROUP BY year, month
ORDER BY year, month;
/* Monthly revenue shows significant fluctuations, indicating non-uniform financial performance across the year.
June and September emerge as high-revenue months, suggesting seasonal peaks in service utilization.
Lower-revenue months highlight opportunities for targeted campaigns and capacity optimization to smooth revenue flow. */

-- Patient 360 View
CREATE VIEW patient_360 AS
SELECT
  p.patient_id,
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  COUNT(DISTINCT a.appointment_id) AS total_appointments,
  SUM(b.amount) AS total_spent,
  MAX(a.appointment_date) AS last_visit
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN billing b ON p.patient_id = b.patient_id AND b.payment_status = 'Paid'
GROUP BY p.patient_id, patient_name;
SELECT * FROM patient_360 ;
/* Patients such as P012, P005, and P010 combine high appointment counts with high total spending, identifying them as core long-term value patients.
Several patients show multiple appointments but NULL total_spent, indicating billing not yet realized or unpaid transactions, which is a revenue follow-up opportunity.
The last_visit date clearly highlights recently active vs inactive patients, enabling quick identification of patients who may require re-engagement.
*/

-- payment method analysis
select payment_method,sum(amount) as total_amount from billing group by payment_method;
/* from creadit card 201382 amount  
   with insurance 182160 amount */
   
-- Inactive Patients
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    MAX(a.appointment_date) AS last_visit,
    DATEDIFF(CURDATE(), MAX(a.appointment_date)) AS days_since_last_visit
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    patient_name
HAVING DATEDIFF(CURDATE(), MAX(a.appointment_date)) > 180
ORDER BY days_since_last_visit DESC;
/* Patients who have not visited for more than 180 days can be considered inactive. 
The hospital can send reminders, follow-up messages, or health-checkup offers to re-engage them.
Note: Since your dataset is historical, CURDATE() may make almost all patients appear inactive. 
For your case study, it may be better to compare against the latest appointment date in the dataset rather than today's date. */