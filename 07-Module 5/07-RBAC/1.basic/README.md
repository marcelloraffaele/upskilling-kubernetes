Testing Authorization with can-i
The first useful tool is the auth can-i command for kubectl. This tool is very useful for testing if a particular user can do a particular action. You can use can-i to validate configuration settings as you configure your cluster, or you can ask users to use the tool to validate their access when filing errors or bug reports. In its simplest usage, the can-i command takes a verb and a resource. For example, this command will indicate if the current kubectl user is authorized to create Pods:
```bash
kubectl auth can-i create pods
```
You can also test subresources like logs or port forwarding with the --subresource
command-line flag:
```bash
kubectl auth can-i get pods --subresource=logs
```