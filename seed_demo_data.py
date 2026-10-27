"""
FitTrack Demo Seed Script
Populates a realistic demo user with 30 days of activities, nutrition, water, weight, sleep, and goals.
Account credentials:
  Email: demo@fittrack.com
  Password: password123
"""

from datetime import date, timedelta
from app import create_app, db
from app.models import User, Activity, FoodRecord, WaterRecord, WeightRecord, SleepRecord, FitnessGoal
from app.utils import calculate_bmi, estimate_calories_burned

app = create_app()

with app.app_context():
    print("Seeding FitTrack demo dataset...")

    # Check or create demo user
    user = User.query.filter_by(email='demo@fittrack.com').first()
    if user:
        print("Clearing old demo records for demo@fittrack.com...")
        db.session.delete(user)
        db.session.commit()

    demo_user = User(
        username='alex_fit',
        email='demo@fittrack.com',
        full_name='Alex Morgan',
        bio='Marathon runner, fitness enthusiast, and health tracking advocate.',
        height_cm=176.0,
        unit_system='metric',
        dark_mode=True,
        water_goal=2500,
        workout_reminder=True,
        water_reminder=True,
        is_admin=True
    )
    demo_user.set_password('password123')
    db.session.add(demo_user)
    db.session.commit()

    today = date.today()

    # 1. Seed 30 Days of Activities
    activity_templates = [
        ('Running', 40, 6.2, 8.5, 'Morning outdoor trail run at brisk pace.'),
        ('Strength Training', 55, 0.0, 5.0, 'Upper body hypertrophy workout (chest, shoulders, triceps).'),
        ('Cycling', 45, 15.0, 7.0, 'Evening scenic road cycling along the river.'),
        ('Yoga & Pilates', 35, 0.0, 3.0, 'Mobility, core balance, and active recovery stretching.'),
        ('HIIT / Calisthenics', 30, 0.0, 8.0, 'High-intensity bodyweight circuit with 45s intervals.'),
        ('Swimming', 45, 1.5, 6.0, 'Freestyle laps and interval sets.')
    ]

    for i in range(29, -1, -1):
        day = today - timedelta(days=i)
        # 5 out of 7 days workout
        if (i % 7) not in [2, 6]:
            template = activity_templates[i % len(activity_templates)]
            act_type, duration, dist, met, notes = template
            cals = estimate_calories_burned(met, duration, 74.0)

            act = Activity(
                user_id=demo_user.id,
                activity_type=act_type,
                duration_minutes=duration,
                distance_km=dist,
                calories_burned=cals,
                activity_date=day,
                notes=notes
            )
            db.session.add(act)

    # 2. Seed 30 Days of Water Records
    for i in range(29, -1, -1):
        day = today - timedelta(days=i)
        # Log 3-5 water drinks per day totaling 2000ml - 2800ml
        for amt in [500, 500, 750, 500]:
            w = WaterRecord(
                user_id=demo_user.id,
                amount_ml=amt,
                record_date=day
            )
            db.session.add(w)

    # 3. Seed Food Records for the past 7 days
    food_samples = [
        ('Breakfast', 'Rolled Oats with Blueberries & Almonds', '1 bowl (300g)', 380, 58, 14, 8),
        ('Lunch', 'Grilled Chicken Salad with Quinoa & Olive Oil', '1 large plate', 540, 42, 45, 18),
        ('Dinner', 'Baked Salmon with Sweet Potato & Asparagus', '1 fillet + veg', 620, 36, 44, 26),
        ('Snack', 'Greek Yogurt with Walnuts & Honey', '1 cup (200g)', 220, 18, 16, 9)
    ]
    for i in range(6, -1, -1):
        day = today - timedelta(days=i)
        for meal_type, food_name, portion, cals, carbs, protein, fat in food_samples:
            f_rec = FoodRecord(
                user_id=demo_user.id,
                meal_type=meal_type,
                food_name=food_name,
                portion_size=portion,
                calories=cals,
                carbs=carbs,
                protein=protein,
                fat=fat,
                record_date=day
            )
            db.session.add(f_rec)

    # 4. Seed Weight Records (Progressive weight trend over 30 days)
    # Starting at 77.0kg down to 73.8kg
    for i in [28, 21, 14, 7, 0]:
        day = today - timedelta(days=i)
        w_val = round(77.0 - (28 - i) * 0.11, 1)
        bmi, cat, _ = calculate_bmi(w_val, 176.0)
        wt = WeightRecord(
            user_id=demo_user.id,
            weight_kg=w_val,
            height_cm=176.0,
            bmi=bmi,
            bmi_category=cat,
            record_date=day,
            notes='Weekly morning fasted weigh-in'
        )
        db.session.add(wt)

    # 5. Seed 30 Days of Sleep Records
    for i in range(29, -1, -1):
        day = today - timedelta(days=i)
        hours = 7.5 if i % 2 == 0 else 8.0
        s = SleepRecord(
            user_id=demo_user.id,
            sleep_time='23:00',
            wake_time='06:30' if hours == 7.5 else '07:00',
            duration_hours=hours,
            quality_rating=4 if i % 3 != 0 else 5,
            record_date=day,
            notes='Deep sleep, regular circadian routine'
        )
        db.session.add(s)

    # 6. Seed Fitness Goals
    goals = [
        FitnessGoal(
            user_id=demo_user.id,
            title='Weekly Workout Consistency',
            category='Workouts',
            target_value=5.0,
            current_value=4.0,
            unit='sessions/wk',
            status='In Progress',
            target_date=today + timedelta(days=60)
        ),
        FitnessGoal(
            user_id=demo_user.id,
            title='Daily Hydration Target',
            category='Water',
            target_value=2500,
            current_value=2250,
            unit='ml/day',
            status='In Progress',
            target_date=today + timedelta(days=30)
        ),
        FitnessGoal(
            user_id=demo_user.id,
            title='Reach Healthy Target Weight',
            category='Weight',
            target_value=73.0,
            current_value=73.8,
            unit='kg',
            status='In Progress',
            target_date=today + timedelta(days=45)
        ),
        FitnessGoal(
            user_id=demo_user.id,
            title='Consistent Sleep Hours',
            category='Sleep',
            target_value=8.0,
            current_value=8.0,
            unit='hours/night',
            status='Completed',
            target_date=today - timedelta(days=2)
        )
    ]
    for g in goals:
        db.session.add(g)

    db.session.commit()
    print("Demo dataset successfully created!")
    print("Login Credentials:")
    print("  Email: demo@fittrack.com")
    print("  Password: password123")
