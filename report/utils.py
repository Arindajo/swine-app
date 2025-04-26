from report.models import Report
from monitor.models import SensorData  



def generate_auto_report():
    sensor_entries = SensorData.objects.all().order_by('-timestamp')

    if sensor_entries.count() < 10:
        return None  # Not enough data yet


    recent_data = sensor_entries[:10]

    # Map activity levels to scores
    activity_score_map = {
        "Low Activity": 1,
        "Moderate Activity": 2,
        "High Activity": 3
    }

    avg_temp = sum([float(entry.temperature) for entry in recent_data]) / 10

    # Convert descriptive activity levels to numbers for averaging
    activity_scores = [activity_score_map.get(entry.activity_level, 0) for entry in recent_data]
    avg_activity_score = sum(activity_scores) / 10

    # You can also reverse map the average score back to a description
    if avg_activity_score < 1.5:
        avg_activity_label = "Low Activity"
    elif avg_activity_score < 2.5:
        avg_activity_label = "Moderate Activity"
    else:
        avg_activity_label = "High Activity"

    title = "Auto Report"
    content = f"Average Temp: {avg_temp:.2f}, Average Activity: {avg_activity_label}"

    report = Report.objects.create(title=title, content=content)
    return report
