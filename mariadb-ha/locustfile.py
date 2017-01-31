from locust import HttpLocust, TaskSet, task

class MyTaskSet(TaskSet):
    @task(2)
    def index(self):
        self.client.get("/")

    @task(1)
    def about(self):
        self.client.post("/",{"summary": "the time is:", "description" : "ciao"})

class MyLocust(HttpLocust):
    task_set = MyTaskSet
    min_wait = 500
    max_wait = 1500